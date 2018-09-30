# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create!(
  name: 'uncategoried',
  display_name: 'selecione ..',
  color: '#ff',
)
Category.create!(
  name: 'market',
  display_name: 'Mercado',
  color: '#ff7c8e',
)
Category.create!(
  display_name: 'Serviços',
  name: 'services',
  help: 'Luz, água, internet, etc ...',
  color: '#7cffd5'
)
Category.create!(
  display_name: 'Lazer',
  name: 'recreation',
  color: '#f9ed90'
)
Category.create!(
  display_name: 'Trasporte',
  name: 'transport',
  color: '#efef8d',
)
Category.create!(
  display_name: 'Salário',
  name: 'salary',
  color: '#8cefbe'
)
Category.create!(
  display_name: 'Saúde',
  name: 'helth',
  color: '#9198ff'
)
Category.create!(
  display_name: 'Alimentação',
  name: 'food',
  color: '#f99b90'
)
Category.create!(
  display_name: 'Investimentos',
  name: 'invest',
  color: '#7cff9f'
)
