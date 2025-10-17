import { QueryClient } from '@tanstack/react-query'

const rawBaseUrl = import.meta.env.VITE_API_URL ?? 'http://localhost:3000'
const API_BASE_URL = rawBaseUrl.replace(/\/$/, '')

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,
      retry: 1,
    },
  },
})

export const createEndpoint = (path: string) =>
  `${API_BASE_URL}${path.startsWith('/') ? path : `/${path}`}`

async function handleResponse<T>(response: Response, fallbackMessage: string): Promise<T> {
  if (!response.ok) {
    const payload = await response.json().catch(() => null)
    const errorMessage =
      payload && typeof payload.error === 'string' ? payload.error : fallbackMessage
    throw new Error(`${errorMessage} (status ${response.status})`)
  }

  return (await response.json()) as T
}

type JsonBody = Record<string, unknown>

export async function postJson<T>(path: string, body: JsonBody, fallbackMessage: string) {
  const response = await fetch(createEndpoint(path), {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

  return handleResponse<T>(response, fallbackMessage)
}
