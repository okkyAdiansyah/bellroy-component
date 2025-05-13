class ShowcaseComponent extends HTMLElement {
    constructor(){
        super();
        this.attachShadow({mode : 'open'})
    }

    connectedCallback(){
        const container = document.createElement('div');
        this.shadowRoot.appendChild(container);

        Elm.Components.Showcase.Main.init({
            node: container
        })
    }
}

customElements.define('elm-showcase', ShowcaseComponent);