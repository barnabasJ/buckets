// Not needed anymore, just leaving it here for reference
function getActive(href, exact) {
    const path = window.location.pathname;
    const hrefPathname = new URL(href).pathname;
    if (exact === "true") {
        return hrefPathname === path;
    } else {
        return path.startsWith(hrefPathname);
    }
}

const createActiveLinkListner = (el) => () => {
    const exact = el.dataset.exact;
    const activeClass = el.dataset.activeClass ?? "active";
    const active = getActive(el.href, exact);
    if (active) {
        el.classList.add(activeClass);
    } else {
        el.classList.remove(activeClass);
    }
};

let listeners = {};

export const NavLink = {
    mounted() {
        console.log(listeners, this.el);
        const listener = createActiveLinkListner(this.el);
        listeners[this.el.id] = listener;
        window.addEventListener("phx:page-loading-stop", listener);
        listener();
    },
    destroyed() {
        console.log(listeners, this.el);
        const listener = listeners[this.el.id]
        if (listener) {
            window.removeEventListener("phx:page-loading-stop", listener);
            listener[this.el.id] = null;
        }
    },
};
