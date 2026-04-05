puts "Seeding..."

# 시드 유저 생성 (없으면)
seed_user = User.find_or_create_by!(email: "seed@example.com") do |u|
  u.provider     = "google"
  u.provider_uid = "seed_uid_001"
  u.nickname     = "seed_user"
  u.email_verified = true
  u.last_sign_in_at = Time.current
end

REGIONS = %w[
  치요다구 주오구 미나토구 신주쿠구 분쿄구
  다이토구 스미다구 고토구 시나가와구 메구로구
  오타구 세타가야구 시부야구 나카노구 스기나미구
  도시마구 기타구 아라카와구 이타바시구 네리마구
  아다치구 가쓰시카구 에도가와구
].freeze

CATEGORIES = %w[가전 가구 주방 생활용품 의류 스타터팩 기타].freeze
STATUSES   = %w[selling selling selling reserved sold].freeze   # selling 비중 높게
PICKUP     = %w[pickup delivery both].freeze

TITLES = {
  "가전" => [ "전자레인지", "냉장고 (소형)", "세탁기", "청소기", "선풍기", "전기포트", "밥솥", "헤어드라이어", "노트북", "모니터" ],
  "가구" => [ "책상", "의자", "침대 프레임", "서랍장", "옷걸이 행거", "책장", "소파", "TV 거치대", "수납 박스 세트", "스탠드 조명" ],
  "주방" => [ "냄비 세트", "프라이팬", "식기 세트", "전기포트", "도마 + 칼 세트", "밥솥", "커피메이커", "수저 세트", "밀폐용기", "그릇 세트" ],
  "생활용품" => [ "이불 세트", "베개", "커튼", "목욕 세트", "청소 도구 세트", "화장대 거울", "세탁망 세트", "욕실 선반", "샤워기 헤드", "행거" ],
  "의류" => [ "겨울 코트", "패딩 점퍼", "청바지", "운동화", "캐주얼 가방", "겨울 부츠", "스니커즈", "백팩", "정장 셔츠", "슬랙스" ],
  "스타터팩" => [ "1인 생활 스타터팩", "주방용품 스타터팩", "가전 스타터팩", "신입생 스타터팩", "원룸 풀세트", "생활용품 패키지", "식기+조리도구 세트", "침구 풀세트", "청소 도구 세트", "욕실 용품 세트" ],
  "기타" => [ "자전거", "킥보드", "악기 (우쿨렐레)", "요가 매트", "덤벨 세트", "캠핑 용품", "텐트", "낚시 용품", "보드게임 세트", "책 묶음" ]
}.freeze

DESCRIPTIONS = [
  "귀국 때문에 급하게 정리합니다. 상태 좋아요.",
  "일본 생활 마무리하면서 팝니다. 직거래 환영해요.",
  "구매한 지 1년 됐는데 거의 안 썼어요. 깨끗합니다.",
  "혼자 살기 시작하시는 분께 딱 맞을 것 같아요.",
  "상태 양호하고 사용감 적어요. 사진 더 필요하면 연락 주세요.",
  "귀국 전까지 써야 해서 거래 시작일 있어요. 확인해 주세요.",
  "저렴하게 드려요. 가져가실 분 빨리 연락 주세요.",
  "박스, 설명서 다 있어요. 거의 새 제품이에요.",
  "유학 마치고 귀국 준비 중이에요. 급처합니다.",
  "직접 수령만 가능해요. 들고 가실 수 있는 분만 연락 주세요."
].freeze

today = Date.today

200.times do |i|
  category = CATEGORIES.sample
  titles   = TITLES[category]
  title    = "#{titles.sample} #{i + 1}번"

  available_from  = today + rand(0..10).days
  departure_date  = available_from + rand(5..30).days

  Item.create!(
    user:           seed_user,
    title:          title,
    description:    DESCRIPTIONS.sample,
    price:          (rand(500..50_000) / 100) * 100,
    category:       category,
    region:         REGIONS.sample,
    pickup_type:    PICKUP.sample,
    status:         STATUSES.sample,
    available_from: available_from,
    departure_date: departure_date,
    images:         []
  )
end

puts "Done! #{Item.count} items total."
