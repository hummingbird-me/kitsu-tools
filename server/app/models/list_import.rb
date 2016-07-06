# == Schema Information
#
# Table name: list_imports
#
#  id                      :integer          not null, primary key
#  type                    :string           not null
#  user_id                 :integer          not null
#  strategy                :integer          not null
#  input_file_file_name    :string
#  input_file_content_type :string
#  input_file_file_size    :integer
#  input_file_updated_at   :datetime
#  input_text              :text
#  status                  :integer          default(0), not null
#  progress                :integer
#  total                   :integer
#  error_message           :text
#  error_trace             :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class ListImport < ActiveRecord::Base
  belongs_to :user, required: true, touch: true

  enum strategy: %i[greater obliterate]
  enum status: %i[queued running failed completed]
  has_attached_file :input_file, s3_permissions: :private

  validates :strategy, presence: true
  validates :input_text, presence: { unless: :input_file? }
  validates_attachment :input_file, presence: { unless: :input_text? }
  validates_attachment :input_file, content_type: { content_type: %w[] }

  # Apply the ListImport
  def apply
    fail 'No each method defined' unless respond_to? :each

    yield({ status: :running, total: count, current: 0 })
    LibraryEntry.transaction do
      each.with_index do |media, data, index|
        entry = LibraryEntry.where(user: user, media: media).first_or_create
        merged_entry(entry, data, strategy).save!
        yield({ status: :running, total: count, current: index + 1 })
      end
    end
    yield({ status: :completed, total: count, current: count })
  rescue StandardError
    yield({ status: :error, total: count })
    raise
  end

  # Apply the ListImport while updating the model db every [frequency] times
  def apply!(frequency: 20)
    apply(user) do |info|
      # Apply every [frequency] updates unless the status is not :running
      if info[:status] != :running || info[:current] % frequency == 0
        update info
        yield info
      end
    end
  end

  def merged_entry(entry, data, strategy)
    case strategy
    when :greater
      # Compare the [completions, progress] tuples and pick the greater
      theirs = data.values_at(:completions, :progress)
      ours = [entry.reconsume_count, entry.progress]

      # -1 if ours, 1 if theirs
      entry.assign_attributes(data) if (theirs <=> ours).positive?
    when :obliterate
      entry.assign_attributes(data)
    end
    entry
  end

  after_create do
    ListImportWorker.perform_async(id)
  end
end
