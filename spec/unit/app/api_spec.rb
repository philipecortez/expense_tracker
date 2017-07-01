require_relative '../../../app/api.rb'
require 'rack/test'

module ExpenseTracker

  RSpec.describe API do
    include Rack::Test::Methods
    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:app) { API.new(ledger: ledger) }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let (:expense)  { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
                             .with(expense)
                             .and_return(RecordResult.new(true, 417, nil))

        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          expect(parsed_response).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        let (:expense) { { 'some' => 'data' } }

        before do
          allow(ledger).to receive(:record)
                              .with(expense)
                              .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)
          expect(parsed_response).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:data' do
      context 'when expenses exists on the given moment' do
        let(:expenses) do
          [Expense.new(10, 50.0, '2017-06-12', 'some place')]
        end
        
        before do
          allow(ledger).to receive(:expenses_on)
                              .with('2017-06-12')
                              .and_return(expenses)
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-12'
          expect(parsed_response.first).to include({"expense_id" => 10})
        end

        it 'responds with status 200 OK' do
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end
      end

      context 'when there is no expenses on the given moment' do
        before do
          allow(ledger).to receive(:expenses_on)
                             .with('2017-06-12')
                             .and_return([])
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2017-06-12'
          expect(parsed_response).to eq([])
        end

        it 'responds with status 200 OK' do
          get '/expenses/2017-06-12'
          expect(last_response.status).to eq(200)
        end
      end
    end

    private

    def parsed_response
      JSON.parse(last_response.body)
    end
  end
end
