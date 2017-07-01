require_relative '../config/sequel'
module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  Expense = Struct.new(:expense_id, :value, :date, :place)

  class Ledger
    def record(expense)
      unless expense.key?('payee')
        message = '`payee` is required'
        return RecordResult.new(false, nil, message)
      end
      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expenses_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
