require 'rack_test'
require 'json'

module ExpenseTracker
  RSpec.describe 'Expense tracker API' do

    it 'records submitted expenses' do
      coffee = {
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      }

      post '/expenses', JSON.generate(coffee)
    end
    
  end
end
