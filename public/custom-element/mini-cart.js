class MiniCart extends HTMLElement{
    constructor(){
        super()
    }
    
    connectedCallback(){
        const container = document.createElement('div');
        this.appendChild(container);

        Elm.Cart.init({
            node: container
        })
    }
}

customElements.define("elm-mini-cart", MiniCart)