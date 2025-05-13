import type { APIRoute } from "astro";

interface option {
    optionColor : String,
    optionImg : String,
    optionCode : String,
}

interface SizeOption {
    sizeCode : String,
    sizeLabel : String
}

interface Product {
    productSKU : String,
    geoID : String,
    isAvailable : Boolean,
    productName : String,
    productSizeOptions : SizeOption [],
    productGallery : String [],
    productPrice : String,
    productOptions : option [],
}

export const GET : APIRoute = async () => {
    const geo = await fetch(
        "https://ipapi.co/json",
        {
            method: 'GET'
        }
    )
    .then(res => res.json())
    .catch(err => {return ""})

    const productBag : Product = {
        productSKU: "SKU1",
        geoID: geo.country ?? "ID",
        isAvailable: false,
        productName: "Lite Travel Pack 30L",
        productSizeOptions: [
            {
                sizeCode: "38L",
                sizeLabel: "Lite Travel Pack 38L"
            },
            {
                sizeCode: "30L",
                sizeLabel: "Lite Travel Pack 30L"
            }
        ],
        productGallery: ["https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/0?auto=format&fit=crop&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/1?auto=format&fit=max&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/2?auto=format&fit=max&"],
        productPrice: "169",
        productOptions: [
            {
                optionColor: "Black",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/0?auto=format&fit=max&",
                optionCode: "363636"
            },
            {
                optionColor: "Ash",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/0?auto=format&fit=max&",
                optionCode: "D9D9D9",
            },
            {
                optionColor: "Clay",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/0?auto=format&fit=max&",
                optionCode: "AF4434"
            }
        ]
    }

    const productKit : Product = {
        productSKU: "SKU2",
        geoID: geo.country ?? "ID",
        isAvailable: true,
        productName: "Tech Kit",
        productSizeOptions: [
            {
                sizeCode: "TK",
                sizeLabel: "Tech Kit"
            },
            {
                sizeCode: "TKC",
                sizeLabel: "Tech Kit Compact"
            }
        ],
        productGallery: ["https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/ETKA-BLK-231/0?auto=format&fit=max&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/ETKA-BSH-228/0?auto=format&fit=max&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/ETKA-BLK-231/2?auto=format&fit=crop&"],
        productPrice: "69",
        productOptions: [
            {
                optionColor: "Black",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/ETKA-BSH-228/0?auto=format&fit=max&",
                optionCode: "363636"
            },
            {
                optionColor: "Slate",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/ETKA-SLT-230/0?auto=format&fit=max&",
                optionCode: "D9D9D9",
            },
            {
                optionColor: "Arcade Gray",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/ETKA-ARG-233/0?auto=format&fit=max&",
                optionCode: "F0F0F0"
            }
        ]
    } 

    const productSling : Product = {
        productSKU: "SKU3",
        geoID: geo.country ?? "ID",
        isAvailable: true,
        productName: "Venture Sling 6L",
        productSizeOptions: [
            {
                sizeCode: "6L",
                sizeLabel: "Venture Sling 6L"
            },
            {
                sizeCode: "9L",
                sizeLabel: "Venture Sling 9L"
            }
        ],
        productGallery: ["https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BMVA-BLK-228/0?auto=format&fit=crop&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BMVA-BLK-228/1?auto=format&fit=crop&", "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BMVA-BLK-228/2?auto=format&fit=max&"],
        productPrice: "129",
        productOptions: [
            {
                optionColor: "Black",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BMVA-BLK-228/0?auto=format&fit=max&",
                optionCode: "363636"
            },
            {
                optionColor: "Bronze",
                optionImg: "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BMVA-BRZ-213/0?auto=format&fit=max&",
                optionCode: "B45628",
            }
        ]
    }

    const products : Product[] = [productBag, productKit, productSling]
    
    
    return new Response(
        JSON.stringify(products), { status: 200 }
    )
}