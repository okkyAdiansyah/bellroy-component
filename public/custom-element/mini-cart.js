class MiniCart extends HTMLElement{
    constructor(){
        super()
        this.shadow = this.attachShadow({mode : 'open'})
    }
    
    connectedCallback(){
        const container = document.createElement('div');
        const dialog = document.createElement('dialog');
        const style = document.createElement('style');
        const closeButton = document.createElement('button');

        dialog.setAttribute('id', 'mini-cart');
        closeButton.setAttribute('class', 'mini-cart__close-btn');
        closeButton.innerText = "x"

        this.shadow.appendChild(style);
        this.shadow.appendChild(dialog);
        dialog.appendChild(container);
        dialog.appendChild(closeButton)

        style.textContent = `
            dialog#mini-cart[open]{
                background: rgba(32, 33, 33, 0.5);
                padding: 0;
                margin: 0;
                border: 0;
                width: 100vw;
                height: 100vh;
                position: fixed;
                inset: 0;
                z-index: 999;
                display: flex;
                justify-content: flex-end;  
            }
            .mini-cart{
                max-width: 90dvw;
                width: 435px;
                height: 100%;
                display: flex;
                flex-direction: column;
                background: #ffffff;
                transform: translateX(100%);
                transition: transform .8s ease-in-out;
            }
            .mini-cart--isActive{
                transform: translateX(0);
            }
            .mini-cart__head{
                width: 100%;
                height: auto;
                display: flex;
                flex-direction: column;
                position: relative;
                align-items: center;
                justify-content: center;
                padding-block: 12px;
            }
            .mini-cart__head-title{
                font-size: 16px;
                font-weight: 400;
                margin: 0;
                color: #9B9B9B;
                line-height: 24px;
            }
            .mini-cart__body{
                height: 100%;
                overflow-y: auto;
                background: oklch(98.5% 0.002 247.839);
            }
            .mini-cart__item{
                padding-block: 16px;
                margin-inline: 1.5rem;
                display: grid;
                grid-template-columns: 90px 1fr;
                column-gap: 2rem;
                position: relative;
            }
            .mini-cart__item:not(:last-child){
                border-bottom: solid 1px #9B9B9B
            }
            .mini-cart__item-label{
                font-size: 13px;
                font-weight: 700;
                text-decoration: none;
                color: #333333;
            }
            .mini-cart__item-variant{
                font-size: 12px;
                font-weight: 400;
                margin: 0;
                color: #9B9B9B;
                line-height: 24px;
            }
            .mini-cart__thumb-container{
                width: 100%;
                height: 80px;
            }
            .mini-cart__thumb{
                width: 100%;
                aspect-ratio: 3 / 2;
                object-fit: contain;    
            }
            .mini-cart__item-price-control{
                width: 100%;
                display: flex;
            }
            .mini-cart__qty-selector{
                -moz-appearance: none;
                -webkit-appearance: none;
                border: 1px solid #b8b8b8;
                border-radius: 0;
                color: #333;
                background-color: #fff;
                font-size: 14px;
                padding: 0 5px;
                min-width: 55px;
                line-height: 24px;
                margin-left: 6px;
            }
            .mini-cart__price{
                font-size: 12px;
                font-weight: 500;
                margin-block: 0;
                margin-left: auto;
                color: #333333;
                line-height: 24px;
            }
            .mini-cart__remove-item-btn{
                position: absolute;
                margin: 0;
                aspect-ratio: 1 / 1;
                width: 42px;
                padding: 4px;
                background: transparent;
                border: none;
                outline: none;
                right: -12px;
                font-weight: 400;
                font-size: 16px;
                cursor: pointer;
                color: #9B9B9B;
            }
            .mini-cart__footer-container{
                padding-block: 12px;
                margin-inline: 20px;
            }
            .mini-cart__footer__subtotal{
                width: 100%;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .mini-cart__footer__subtotal{
                font-size: 16px;
                font-weight: 500;
                margin-block: 0;
                margin-left: auto;
                color: #333333;
                line-height: 24px;
            }
            .mini-cart__checkout-btn{
                width: 100%;
                display: flex;
                justify-content: center;
                padding-block: 12px;
                background: #E15A1D;
                color: #ffffff;
                font-weight: 700;
                border-radius: 6px;
                text-decoration: none;
            }
            .cart-indicator-container{
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            .cart-indicator-badge{
                box-sizing: content-box !important;
                position: absolute;
                top: -5px;
                right: -5px;
                height: 13px;
                min-width: 8px;
                border-radius: 8px;
                background-color: #e15a1d;
                padding: 0 2.5px;
                color: #fff;
                font-family: Lucida Console, Monaco, monospace;
                font-size: 9px;
                font-weight: 700;
                line-height: 13px;
                white-space: nowrap;
                text-align: center;
                border: 2px solid #fff;
            }
            .mini-cart__close-btn{
                position: absolute;
                margin: 0;
                aspect-ratio: 1 / 1;
                width: 64px;
                padding: 4px;
                background: transparent;
                border: none;
                outline: none;
                right: 12px;
                font-weight: 400;
                font-size: 24px;
                cursor: pointer;
                color: #9B9B9B;
            }
        `
        
        const app = Elm.Cart.init({
            node: container
        })

        app.ports.updateCart.subscribe((data) => {
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
                const event = new CustomEvent('update-cart', { detail: { cartItems: data }, bubbles: true, composed: true});
                window.dispatchEvent(event);
            })
            .catch(err => console.error("Failed to update cart", err));
        })

        window.addEventListener('open-mini-cart', (e) => {
            const cartStatus = e.detail;

            app.ports.openMiniCart.send(true);
        })

        window.addEventListener('add-to-cart', (e) => {
            const cartItems = e.detail.cartItems

            app.ports.recieveCartfromProduct.send(cartItems)
        })

        closeButton.addEventListener('click', (e) => {
            dialog.removeAttribute('open');

            app.ports.openMiniCart.send(false);
        })
    }
}

customElements.define("elm-mini-cart", MiniCart)