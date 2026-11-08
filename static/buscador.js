const campo = document.getElementById("campo-busqueda");
const boton = document.getElementById("btn-buscar");
const mensaje = document.getElementById("mensaje-busqueda");
const grid = document.getElementById("grid-plagas");

// Guardamos las tarjetas que ya tiene la página para poder restaurarlas
const tarjetasOriginales = grid.innerHTML;

// Evita que un texto de la base rompa el HTML
function escapar(texto) {
    return String(texto ?? "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#39;");
}

function crearTarjeta(plaga) {
    const imagen = plaga.imagen_url
        ? `<img src="/static/${encodeURI(plaga.imagen_url)}" alt="${escapar(plaga.nombre)}">`
        : "";
    const tipo = plaga.tipo === "plaga" ? "Plaga" : "Enfermedad";
    return `
    <article class="tarjeta">
      <div class="tarjeta-img">${imagen}</div>
      <div class="tarjeta-info">
        <span class="etiqueta-tipo">${tipo}</span>
        <h3>${escapar(plaga.nombre)}</h3>
        <p class="nombre-cientifico">${escapar(plaga.nombre_cientifico)}</p>
        <p class="descripcion">${escapar(plaga.descripcion)}</p>
      </div>
    </article>`;
}

async function buscar() {
    const texto = campo.value.trim();
    mensaje.textContent = "";

    try {
        const respuesta = await fetch("/api/plagas/buscar?q=" + encodeURIComponent(texto));
        const datos = await respuesta.json();

        if (!respuesta.ok) {
            // 400 = texto no válido, 404 = sin resultados
            mensaje.textContent = datos.error || datos.mensaje;
            if (respuesta.status === 404) {
                grid.innerHTML = "";
            }
            return;
        }

        grid.classList.add("resultados-busqueda");
        grid.innerHTML = datos.resultados.map(crearTarjeta).join("");
    } catch (error) {
        mensaje.textContent = "No pudimos conectar con el servidor. Intenta de nuevo.";
    }
}

boton.addEventListener("click", buscar);

campo.addEventListener("keydown", (evento) => {
    if (evento.key === "Enter") {
        buscar();
    }
});

// Si la persona borra el texto, volvemos a mostrar todas las tarjetas
campo.addEventListener("input", () => {
    if (campo.value.trim() === "") {
        grid.classList.remove("resultados-busqueda");
        grid.innerHTML = tarjetasOriginales;
        mensaje.textContent = "";
    }
});