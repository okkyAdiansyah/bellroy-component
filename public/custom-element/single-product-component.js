class SingleProductComponent extends HTMLElement{
    constructor(){
        super()
    }

    connectedCallback(){
        const container = document.createElement('div');
        this.appendChild(container);

        Elm.Components.Single.Main.init({
            node: container
        })
    }
}

customElements.define("elm-single-product", SingleProductComponent);