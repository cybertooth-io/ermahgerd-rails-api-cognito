# frozen_string_literal: true

ADMIN = Role.find_by key: 'ADMIN'

User.seed_once(
  :email,
  {
    email: 'dan.nelson@cybertooth.io',
    roles: [ADMIN]
  },
  email: 'bradf.83@gmail.com',
  roles: [ADMIN]
)
