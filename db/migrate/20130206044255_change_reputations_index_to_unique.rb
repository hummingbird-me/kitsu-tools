##
#  Copyright 2012 Twitter, Inc
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##

class ChangeReputationsIndexToUnique < ActiveRecord::Migration
  def self.up
    remove_index :rs_reputations, :name => "index_rs_reputations_on_reputation_name_and_target"
    add_index :rs_reputations, [:reputation_name, :target_id, :target_type], :name => "index_rs_reputations_on_reputation_name_and_target", :unique => true
  end

  def self.down
    remove_index :rs_reputations, :name => "index_rs_reputations_on_reputation_name_and_target"
    add_index :rs_reputations, [:reputation_name, :target_id, :target_type], :name => "index_rs_reputations_on_reputation_name_and_target"
  end
end
