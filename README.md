# Amenitiz Checkout Challenge

This project solves the Amenitiz checkout challenge with a Ruby on Rails backend and a Vite/React frontend. The API exposes a stateless `/checkout` endpoint that applies business pricing rules (buy-one-get-one for tea, bulk discount for strawberries, percentage drop for coffee). The React UI lets users build a basket, see discounts in real time, and experiment with different item combinations.

## 🚀 Features Delivered

- ✅ Domain service (`CashRegister::Services::Checkout`) with reusable pricing rules
- ✅ API endpoint (`POST /checkout`) that validates payloads and returns totals
- ✅ RSpec suite covering domain logic and request behaviour
- ✅ React/Tailwind UI with catalog, basket controls, and live totals via React Query
- ✅ Shared React Query client and hook (`useCheckout`) for consistent data fetching

## 🔮 Future Enhancements

- ⚙️ Frontend tests
- 🔁 Toggle-able rounding strategy (per-unit vs aggregate) to match different receipt rules
- 🗂️ Persist checkout history in the database for auditing/analytics
- 🙍 Authentication and multi-user baskets
- 📊 Observability: structured logging, metrics, and better error reporting

## 🧰 Tech Stack

- **Backend:** Ruby on Rails 8, PostgreSQL (development), SQLite (tests)
- **Frontend:** React 19, Vite 7, TypeScript, Tailwind CSS, React Query
- **Tooling:** RSpec, Vitest, ESLint, Prettier

## ⚙️ Local Setup

### 1. Clone the repository

```bash
git clone https://github.com/AlexandreBonfim/amenitiz-challenge.git
cd amenitiz-challenge
```

### 2. Environment variables

Create `backend/.env`:

```env
POSTGRES_PASSWORD=postgres
RAILS_ENV=development
FRONTEND_ORIGIN='http://localhost:5173'
```

### 3. Backend setup (local)

```bash
cd backend
bundle install
bundle exec rails db:test:prepare
```

Run the API (default port `3000`):

```bash
bundle exec rails server
```

### 4. Frontend setup (local)

```bash
cd frontend
npm install
npm run dev
```

## 🐳 Run with Docker

> Requires Docker and Docker Compose.

### 1. Build containers

```bash
docker compose build
```

### 2. Launch the stack

```bash
docker compose up
```

- Rails API → http://localhost:3000  
- Vite frontend → http://localhost:5173  

Shut down:

```bash
docker compose down
```

## ✅ Tests & Quality

- Backend tests: `cd backend && bundle exec rspec`
- Lint/format (frontend): `npm run lint` / `npm run format`

## 🧭 API Overview

### `POST /checkout`

Request body:

```json
{ "items": ["GR1", "SR1", "CF1"] }
```

Response:

```json
{
  "items": ["GR1", "SR1", "CF1"],
  "subtotal": "19.34",
  "discount": "3.11",
  "total": "16.23"
}
```

Invalid product codes return `422` with `{ "error": "Unknown product: XYZ" }`.

## 📝 Notes

- Pricing rules live under `backend/app/domain/cash_register/rules` and can be extended easily.
- The frontend uses Tailwind utility classes exclusively—`src/App.css` just imports Tailwind.
- React Query configuration and the shared helper live in `frontend/src/api/client.ts`.
- CORS is controlled via `FRONTEND_ORIGIN`; change it per environment as needed.

Enjoy experimenting with the Amenitiz checkout!***
