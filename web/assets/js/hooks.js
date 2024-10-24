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

let listeners = {
    NavLink: {},
    MultiSelect: {},
};

export const NavLink = {
    mounted() {
        console.log(listeners, this.el);
        const listener = createActiveLinkListner(this.el);
        listeners["NavLink"][this.el.id] = listener;
        window.addEventListener("phx:page-loading-stop", listener);
        listener();
    },
    destroyed() {
        console.log(listeners, this.el);
        const listener = listeners["NavLink"][this.el.id]
        if (listener) {
            window.removeEventListener("phx:page-loading-stop", listener);
            listener["NavLink"][this.el.id] = null;
        }
    },
};

export const MultiSelect = {
    mounted() {
        console.log("mounted");
        // const button = document.getElementById(`selected-options-container-${id}`)
        // button.setAttribute("aria-expanded", "false");
        const listener = (e) => {
            e.preventDefault();
            const id = e.detail.id;
            const focused = document.activeElement;
            console.log(focused, id);
            if (focused.id === `selected-options-container-${id}`) {
                const button = document.getElementById(`selected-options-container-${id}`)
                button.setAttribute("aria-expanded", "true");
                // need to wait until the options are visible
                setTimeout(() => {
                    console.log("focus on first option", document.getElementById(`${id}-option-0`));
                    document.getElementById(`${id}-option-0`).focus();
                }, 20);
            } else if (document.getElementById(`options-container-${id}`).contains(focused)) {
                const button = document.getElementById(`selected-options-container-${id}`)
                button.focus();
                button.setAttribute("aria-expanded", "false");
            }
        }
        listeners["MultiSelect"][this.el.id] = listener;
        this.el.addEventListener("multi-select-toggle", listener);
    },
    destroyed() {
        const listener = listeners["Dropdown"][this.el.id]
        if (listener) {
            window.removeEventListener("multi-select-toggle", listener);
            listener["MultiSelect"][this.el.id] = null;
        }
    },
};
