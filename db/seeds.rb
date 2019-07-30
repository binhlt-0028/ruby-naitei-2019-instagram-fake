Admin.create! name: "admin",
             password: "admin"

User.create! name: "user",
             email: "user@user.com",
             password: "123456",
             non_block: true,
             activated: true
User.create! name: "user2",
             email: "user2@user.com",
             password: "123456",
             non_block: true,
             activated: true
