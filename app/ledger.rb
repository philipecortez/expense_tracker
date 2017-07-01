module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  Expense = Struct.new(:expense_id, :value, :date, :place)

  class Ledger
    def record(expense)
    end

    def expense_on(date)
    end
  end
end
