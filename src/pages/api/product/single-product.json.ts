import type { APIRoute } from "astro";

interface Spec{
    capacity: String,
    weight: String,
    dimension: String,
    materials: String,
    composition: String
}

interface ColorVariant{
    variant_code: String,
    variant_label: String,
    is_stock: Boolean,
    galleries: String[],
}

interface ProductVar {
    var_label: String,
    var_sku: String,
    price: String,
    slug: String,
    subtext: String,
    color_variant: ColorVariant[],
    spec: Spec
}

interface SingleProduct {
    product_label: String,
    product_video: String,
    features: String[],
    variables: ProductVar[]
    warranty_time: String
}

export const GET : APIRoute = async () => {
    const LT : SingleProduct = {
        product_label: "lite-travel-pack",
        product_video: "blob:https://www.youtube-nocookie.com/fa5281f3-0810-4804-8072-804e526297de",
        features: [
            "Folds out flat for easy packing",
            "Quick-access top pocket for passport and essentials",
            "Tuck-away shoulder straps",
            "Lower exterior pocket fits an extra layer",
            "Internal mesh packing cells and dividers",
            "Rear-up laptop pocket fits 16” laptops",
            "Luggage pass-through",
            "Removable sternum strap",
            "External attachment loops",
            "Main material: Dura Lite Nylon",
            "Internal Apple AirTag slip pocket"
        ],
        variables: [
            {
                var_label: "Lite Travel Pack 30L",
                var_sku: "LTP30",
                price: "199",
                slug: "lite-travel-pack-30",
                subtext: "Lightweight, comfortable and oh-so packable, this compact carry-on backpack is standing by to optimize your travel quiver.",
                color_variant: [
                    {
                        variant_code: "BLPA-BLK-241",
                        variant_label: "Black (Leather Free)",
                        is_stock: true,
                        galleries: [
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/0?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/1?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/2?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/3?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/4?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/5?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/6?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/7?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/8?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/9?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/10?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/11?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/12?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/13?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/14?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-BLK-241/15?auto=format&fit=crop&"
                        ]
                    },
                    {
                        variant_code: "BLPA-ASH-241",
                        variant_label: "Ash (Leather Free)",
                        is_stock: true,
                        galleries: [
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/0?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/1?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/2?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/3?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/4?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/5?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/6?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/7?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/8?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/9?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/10?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/11?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/12?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/13?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/14?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-ASH-241/15?auto=format&fit=crop&",
                        ]
                    },
                    {
                        variant_code: "BLPA-CLY-241",
                        variant_label: "Ash (Leather Free)",
                        is_stock: true,
                        galleries: [
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/0?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/1?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/2?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/3?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/4?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/5?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/6?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/7?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/8?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/9?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/10?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/11?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/12?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/13?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/14?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPA-CLY-241/15?auto=format&fit=crop&",
                        ]
                    }
                ],
                spec: {
                    capacity: "30L",
                    weight: "950g",
                    dimension: "500 × 360 × 120 mm",
                    materials: "We use fabrics from recycled sources such as plastic PET bottles, industrial nylon offcuts and fishing nets. (See composition.)",
                    composition: "75% Recycled Nylon, 5% Recycled Polyester, 5% Polyester, 5% Other materials, 5% Nylon, 5% Foam"
                }
            },
            {
                var_label: "Lite Travel Pack 38L",
                var_sku: "LTP38",
                price: "299",
                slug: "lite-travel-pack-38",
                subtext: "Lightweight, comfortable and oh-so packable, this large carry-on backpack is standing by to optimize your travel quiver.",
                color_variant: [
                    {
                        variant_code: "BLPB-BLK-241",
                        variant_label: "Black (Leather Free)",
                        is_stock: true,
                        galleries: [
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/0?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/1?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/2?auto=format&fit=max&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/3?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/4?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/5?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/6?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/7?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/8?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/9?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/10?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/11?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/12?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/13?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/14?auto=format&fit=crop&",
                            "https://bellroy-product-images.imgix.net/bellroy_dot_com_gallery_image/USD/BLPB-BLK-241/15?auto=format&fit=crop&",
                        ]
                    }
                ],
                spec: {
                    capacity: "38L",
                    weight: "1Kg",
                    dimension: "520 × 370 × 170 mm",
                    materials: "We use fabrics from recycled sources such as plastic PET bottles, industrial nylon offcuts and fishing nets. (See composition.)",
                    composition: "75% Recycled Nylon, 5% Recycled Polyester, 5% Polyester, 5% Other materials, 5% Nylon, 5% Foam"
                }
            },
        ],
        warranty_time: "6"
    }

    return new Response(
        JSON.stringify({data: LT}),
        {status: 200}
    )
}
