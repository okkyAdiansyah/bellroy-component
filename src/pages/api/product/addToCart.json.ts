import type { APIRoute } from "astro";
import type { Cart } from "./featured-product.json";

export const prerender = false;

export const POST: APIRoute = async ({request, cookies}) => {
  if(request.headers.get("Content-Type") === "application/json"){
    const body = await request.json()
    try{
      cookies.set('cart', JSON.stringify(body), {
        path: '/',
        httpOnly: false,
        sameSite: 'strict',
        maxAge: 60 * 60 * 24 * 7
      });
      return new Response (JSON.stringify(body), {status: 200})
    }catch(err){
      return new Response("Failed to set cookies", {status: 400})
    }
  } else {
    return new Response("Body is not set", {status: 404})
  }

}

export const GET: APIRoute = async ({cookies}) => {
  const cookie = cookies.get('cart')?.value
  try{
    return new Response(cookie, {status: 200})
  }catch(err){
    return new Response("Error", {status: 400})
  }
}
