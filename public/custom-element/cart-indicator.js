class CartIndicator extends HTMLElement {
  connectedCallback() {
    const container = document.createElement('div');
    const mode = this.getAttribute('data-mode') || 'cart-toggle';
    const cart = this.getAttribute('data-cart');

    this.appendChild(container)
    
    const app = Elm.CartIndicator.init({
      node: container,
      flags: {
        mode: mode,
        cartItem: parseInt(cart) || 0
      }
    });

    const openMiniCart = new CustomEvent("open-mini-cart", {detail : true, bubbles: true, composed: true});


    this.addEventListener('click', (e) => {
      const miniCart = document.querySelector('elm-mini-cart');
      const shadow = miniCart.shadowRoot;
      const dialog = shadow.getElementById('mini-cart');

      this.dispatchEvent(openMiniCart);
      dialog.setAttribute('open', '');
    })

    window.addEventListener('add-to-cart', (e) => {
      const newCartItems = e.detail.cartItems.length

      app.ports.recieveCartFromJs.send(newCartItems)
    })

    window.addEventListener('update-cart', (e) => {
      const newCartItems = e.detail.cartItems.length

      app.ports.recieveCartFromJs.send(newCartItems)
    })

  }
}

customElements.define('elm-cart-indicator', CartIndicator);