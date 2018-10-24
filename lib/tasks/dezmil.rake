namespace :dezmil do
  desc 'List statements and transactions by user'
  task statements_and_transactions_by_user: :environment do
    Rails.logger.silence do 
      printf "%-40s %10s %10s\n\n", "email", "statements", "transactions"
      User.all.each do |user| 
        printf "%-40s %10d %10d\n", user.email, user.statements.count, user.transactions.count
      end
    end
  end

  task my_transactions: :environment do
    Rails.logger.silence do
      User.find_by(email: 'danielhilst@gmail.com').transactions.order('transactions.id desc').each do |t|
        printf "% 5d % 5d %-20s %-20s %-70s %10.2f %10.2f\n", t.statement.id, t.id, t.statement.date.to_date, t.date, t.memo, t.amount, t.balance 
      end
    end
  end

  task :help do
    p 'dezmil:stbu'
    p 'dezmil:t'
  end

  task s: :statements_and_transactions_by_user
  task t: :my_transactions
  task defaut: :help
end
