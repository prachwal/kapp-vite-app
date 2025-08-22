// services/api.ts
/**
 * Testuje endpoint API /api/health
 * @returns Promise<string> - odpowiedź z API lub komunikat o błędzie
 */
export async function testApi(): Promise<string> {
  try {
    const res = await fetch("/api/health");
    if (!res.ok) {
      return `Błąd API: ${res.status}`;
    }
    const data = await res.text();
    return data;
  } catch (err) {
    return `Błąd sieci: ${err}`;
  }
}
