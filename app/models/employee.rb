class Employee < ApplicationRecord
  VALID_GENDER = %w(male female)

  scope :by_gender, ->(gender) do
    if VALID_GENDER.include?(gender)
      Rails.cache.fetch("employees_#{gender}") { puts 'evaluating...' ; where gender: gender }
    else
      Rails.cache.fetch('all_employees') { puts 'evaluating...' ; all }
    end
  end

  after_commit :flush_cache!

  private

  def flush_cache!
    puts 'flushing the cache...'
    Rails.cache.delete 'all_employees'
    Rails.cache.delete "employees_gender#{gender}"
  end
end
