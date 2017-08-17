class Filing < ApplicationRecord
  after_create_commit { FilingScrapperJob.perform_later self }
end
