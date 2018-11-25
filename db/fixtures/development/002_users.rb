# frozen_string_literal: true

ADMIN = Role.find_by key: 'ADMIN'

User.seed_once(
  :email,
  {
    email: 'dan@cybertooth.io',
    first_name: 'Dan',
    last_name: 'Nelson',
    nickname: 'Hollywood',
    roles: [ADMIN]
  },
  email: 'bradf.83@gmail.com',
  first_name: 'Brad',
  last_name: 'Fontaine',
  nickname: 'Gorilla',
  roles: [ADMIN]
)
