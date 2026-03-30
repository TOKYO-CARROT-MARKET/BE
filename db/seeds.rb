Item.destroy_all
User.destroy_all

user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

Item.create!(
  [
    {
      user: user,
      title: "전자레인지 팝니다",
      description: "귀국 때문에 정리합니다. 상태 좋아요.",
      price: 3000,
      category: "가전",
      region: "신주쿠",
      pickup_type: "pickup",
      available_from: Date.new(2026, 4, 2),
      departure_date: Date.new(2026, 4, 10),
      status: "selling"
    },
    {
      user: user,
      title: "책상 + 의자 세트",
      description: "유학생 스타터용으로 좋아요.",
      price: 5000,
      category: "가구",
      region: "다카다노바바",
      pickup_type: "both",
      available_from: Date.new(2026, 4, 1),
      departure_date: Date.new(2026, 4, 15),
      status: "reserved"
    }
  ]
)