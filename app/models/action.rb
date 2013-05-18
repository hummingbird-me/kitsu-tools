class Action < ActiveRecord::Base
  serialize :data, ActiveRecord::Coders::Hstore

  after_create do
    ActionProcessingWorker.perform_async(self.id)
  end
end
