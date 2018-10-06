# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Category.find_or_create_by( 
#   name: 'uncategoried',
#   display_name: 'selecione ..',
#   color: '#ff',
# )
# Category.find_or_create_by( 
#   name: 'market',
#   display_name: 'Mercado',
#   color: '#ff7c8e',
# )
# Category.find_or_create_by( 
#   display_name: 'Serviços',
#   name: 'services',
#   help: 'Luz, água, internet, etc ...',
#   color: '#7cffd5'
# )
# Category.find_or_create_by( 
#   display_name: 'Lazer',
#   name: 'recreation',
#   color: '#f9ed90'
# )
# Category.find_or_create_by( 
#   display_name: 'Trasporte',
#   name: 'transport',
#   color: '#efef8d',
# )
# Category.find_or_create_by( 
#   display_name: 'Salário',
#   name: 'salary',
#   color: '#8cefbe'
# )
# Category.find_or_create_by( 
#   display_name: 'Saúde',
#   name: 'helth',
#   color: '#9198ff'
# )
# Category.find_or_create_by( 
#   display_name: 'Alimentação',
#   name: 'food',
#   color: '#f99b90'
# )
# Category.find_or_create_by( 
#   display_name: 'Investimentos',
#   name: 'invest',
#   color: '#7cff9f'
# )
# Category.find_or_create_by( 
#   display_name: 'Pet',
#   name: 'pet',
#   color: '#7ccfaf'
# )
# Category.find_or_create_by( 
#   display_name: 'Cartão de Credito',
#   name: 'credit_cart',
#   color: '#7ccfaf'
# )
# Category.find_or_create_by( 
#   display_name: 'Taxas',
#   name: 'tax',
#   color: '#7ccfaf'
# )
# Category.find_or_create_by( 
#   display_name: 'Casa',
#   name: 'house',
#   color: '#91a8fa'
# )
Category.find_or_create_by( 
  display_name: 'Saques',
  name: 'withdraw',
  color: '#9caafa'
)
Category.find_or_create_by( 
  display_name: 'Roupas',
  name: 'cloth',
  color: '#01a8fa'
)
Category.find_or_create_by( 
  display_name: 'Educação',
  name: 'education',
  color: '#9100fa'
)
Category.find_or_create_by( 
  display_name: 'Desinvestimento',
  name: 'divestiment',
  color: '#a10afa'
)
Category.find_or_create_by( 
  display_name: 'Receita',
  name: 'revenue',
  color: '#a10afa'
)
