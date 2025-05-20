class CartIndicator extends HTMLElement {
  connectedCallback() {
    const mode = this.getAttribute('data-mode') || 'cart-toggle';
    const cart = this.getAttribute('data-cart')
    
    const app = Elm.CartIndicator.init({
      node: this,
      flags: {
        mode: mode,
        cartItem: parseInt(cart) || 0
      }
    });

    window.addEventListener('add-to-cart', (e) => {
      const newCartItems = e.detail.cartItems.length
      // console.log(newCartItems)
      app.ports.recieveCartFromJs.send(newCartItems)
    })
  }
}

customElements.define('elm-cart-indicator', CartIndicator);