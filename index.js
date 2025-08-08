const express = require("express"); // Cambia el import por require
const path = require("path");

const app = express();
const port = process.env.PORT || 3000;

app.get("/", (req, res) => {
  // Construye la ruta al archivo index.html
  // La ruta es ahora src/views
  const rutaArchivoHTML = path.join(__dirname, "src", "views", "welcome.html");

  // Usa res.sendFile() para enviar el archivo
  res.sendFile(rutaArchivoHTML, (err) => {
    if (err) {
      // Si hay un error, lo registramos y enviamos un código de estado 500
      console.error("Error al enviar el archivo:", err);
      res.status(500).send("Error interno del servidor.");
    }
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`Servicio 2 escuchando en el puerto ${port}`);
});
