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

  task stbu: :statements_and_transactions_by_user
end
