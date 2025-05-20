import type { APIRoute } from "astro";

interface ProductOption {
    product_img : String,
    product_color_code : String
    product_color_name : String
}

interface Product {
    product_sku : String,
    is_new : Boolean,
    product_name : String,
    product_slug : String,
    product_price : String,
    product_feat : String,
    product_options : ProductOption []
}

export interface Cart {
    label : String,
    img : String, 
    color_variant : String,
    qty : Number, 
    price : Number
}

export const GET : APIRoute = async ({cookies}) => {
    const carts : Cart[] = [
        {
            label : "Lite Travel Pack 30L",
            img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/0?auto=format&fit=crop&",
            color_variant : "Black (Leather Free)",
            qty : 1,
            price : 199
        },
        {
            label : "Lite Travel Pack 38L",
            img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/0?auto=format&fit=crop&",
            color_variant : "Black (Leather Free)",
            qty : 1,
            price : 299
        }
    ]

    const cookiesExists = cookies.get('cart')?.value
    if(!cookiesExists){
        try{
                cookies.set('cart', JSON.stringify(carts), {
                path: '/',
                httpOnly: false,
                sameSite : "lax",
                maxAge: 60 * 60 * 24 * 7,
                });
        } catch (err){
            console.error(err)
        }
    }

    const products : Product [] = [
        {
            product_sku : "TCO1",
            is_new : true,
            product_name : "Transit Carry On",
            product_slug : "transit-carry-on",
            product_price : "299",
            product_feat : "41L volume / Hard shell, optimized for carry-on",
            product_options : [
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/LTCA-BLK-506/0?auto=format&fit=max&",
                    product_color_code : "#363636",
                    product_color_name : "Black"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/LTCA-CHK-506/0?auto=format&fit=max&",
                    product_color_code : "#e9e6de",
                    product_color_name : "Chalk"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/LTCA-EGD-506/0?auto=format&fit=max&",
                    product_color_code : "#5d736f",
                    product_color_name : "Everglade"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/LTCA-BRZ-506/0?auto=format&fit=max&",
                    product_color_code : "#b45628",
                    product_color_name : "Bronze"
                },
            ]
        },
        {
            product_sku : "LTP1",
            is_new : false,
            product_name : "Lite Travel Pack 30L",
            product_slug : "lite-travel-pack-30l",
            product_price : "199",
            product_feat : "30L / Compact and optimized for carry-on",
            product_options : [
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/BLPA-BLK-241/0?auto=format&fit=max&",
                    product_color_code : "#363636",
                    product_color_name : "Black"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/BLPA-ASH-241/0?auto=format&fit=max&",
                    product_color_code : "#dcdcdc",
                    product_color_name : "Ash"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/BLPA-CLY-241/0?auto=format&fit=max&",
                    product_color_code : "#af4434",
                    product_color_name : "Clay"
                },
            ]
        },
        {
            product_sku : "TK1",
            is_new : false,
            product_name : "Tech Kit",
            product_slug : "tech-kit",
            product_price : "59",
            product_feat : "Charger, mouse, powerbank, dongles, cables, earbuds",
            product_options : [
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-BLK-231/0?auto=format&fit=max&",
                    product_color_code : "#363636",
                    product_color_name : "Black"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-SLT-230/0?auto=format&fit=max&",
                    product_color_code : "#5b5b58",
                    product_color_name : "Slate"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-ARG-233/0?auto=format&fit=max&",
                    product_color_code : "#f0f0f0",
                    product_color_name : "Arcade Gray"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-NAV-227/0?auto=format&fit=max&",
                    product_color_code : "#212e41",
                    product_color_name : "Navy"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-EUC-230/0?auto=format&fit=max&",
                    product_color_code : "#a8b8b2", 
                    product_color_name : "Eucalyptus"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-BRZ-213/0?auto=format&fit=max&",
                    product_color_code : "#b45628", 
                    product_color_name : "Bronze"
                },
                {
                    product_img : "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-SAB-217/0?auto=format&fit=max&",
                    product_color_code : "#e4d9cb", 
                    product_color_name : "Saltbrush"
                },
            ]
        },
    ]
    
    return new Response(
        JSON.stringify({data : products}), { status: 200 }
    )
}