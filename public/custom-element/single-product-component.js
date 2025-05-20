class SingleProductComponent extends HTMLElement{
    constructor(){
        super()
    }

    connectedCallback(){
        const rawData = this.getAttribute("data-cart-items")
        let cartItems = []

        try{
            cartItems = JSON.parse(rawData || []);
        }catch(err){
            console.error("failed to parse", err)
        }

        const app = Elm.Components.Single.Main.init({
            node: this,
            flags: {
                cart_items: cartItems
            }
        })

        app.ports.sendCartToJs.subscribe((data) => {
            fetch('http://localhost:4321/api/product/addToCart.json',
                {
                    method: "POST",
                    body: JSON.stringify(data),
                    headers: {
                        'Content-Type' : 'application/json'
                    }
                }
            )
            .then(() => {
                const event = new CustomEvent('add-to-cart', { detail: { cartItems: data } });
                window.dispatchEvent(event);
            })
            .catch(err => console.error("Failed to update cart", err));
        })
    }
}

customElements.define("elm-single-product", SingleProductComponent);