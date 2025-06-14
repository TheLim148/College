const API_URL = "http://localhost:3000/products";

//Получение нужных элементов
const productList = document.getElementById("productList");
const addProductBtn = document.getElementById("addProductBtn");
const productModal = document.getElementById("productModal");
const modalTitle = document.getElementById("modalTitle");
const productForm = document.getElementById("productForm");
const closeBtn = document.querySelector(".close");

//Получение инпутов
const nameInput = document.getElementById("name");
const descriptionInput = document.getElementById("description");
const priceInput = document.getElementById("price");
const stockInput = document.getElementById("stock");
const typeInput = document.getElementById("type");

let editingProductId = null; //Какой товар редактирует польщователь

//Функция для открытия модального окна
function openModal(edit = false, product = {}) {
  productModal.classList.remove("hidden"); //Делаем его видимым
  modalTitle.textContent = edit ? "Редактировть товар" : "Добавить товар"; //Если мы не редактируем товар, то мы его добавляем, иначе редактируем
  editingProductId = edit ? product.id : null //Если мы редактируем, то определённый айди, иначе пустой

  nameInput.value = product.name || "";
  descriptionInput.value = product.description || "";
  priceInput.value = product.price || ""; //заполняем значения (Либо введённые данные, либо пустые строки)
  stockInput.value = product.stock || "";
  typeInput.value = product.type || "";
}

//Закрытие модального окна
function closeModal() {
  productModal.classList.add("hidden"); //Делаем его невиидмым
  productForm.reset(); //Перезапускаем форму
  editingProductId = null; //Не редактируем товар
}

//Функция для крестика, чтобы закрыть окно
closeBtn.addEventListener("click", closeModal);
window.addEventListener("click", (e) => {
  if (e.target === productModal) closeModal();
});

addProductBtn.addEventListener("click", () => openModal()); //Функция для открытия окна

//
productForm.addEventListener("submit", async (e) => {
  e.preventDefault(); //Отменяет отправку формы
  const productData = {
    name: nameInput.value,
    description: descriptionInput.value,
    price: +priceInput.value, //Создаём данные для карточки
    stock: +stockInput.value,
    type: typeInput.value
  };
  if (editingProductId) { //Если мы редактируем, то вызываем PUT
    await fetch(`${API_URL}/${editingProductId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(productData)
    });
  }
  else { //Иначе POST
    await fetch(API_URL, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(productData)
    });
  }
  closeModal(); //Закрываем окно
  loadProducts(); //Загружаем товары
});

async function deleteProduct(id) { //Удаление товраа
  await fetch(`${API_URL}/${id}`, { method: "DELETE" });
  loadProducts();
}

function createCard(product) { //Создание самой карточки
  const card = document.createElement("div");
  card.className = "card"
  card.innerHTML = `
      <h3>${product.name}</h3>
      <p><b>Описание:</b> ${product.description}</p>
      <p><b>Цена:</b> ${product.price} ₽</p>
      <p><b>Склад:</b> ${product.stock}</p>
      <p><b>Тип:</b> ${product.type}</p>
      <div class="actions">
      <button class="edit">Редактировать</button>
      <button class="delete">Удалить</button>
      </div>
  `
  card.querySelector(".edit").addEventListener("click", () => openModal(true, product));
  card.querySelector(".delete").addEventListener("click", () => deleteProduct(product.id))
  return card;
}

//Функция для загрузки товаров
async function loadProducts() {
  productList.innerHTML = "";
  const res = await fetch(API_URL); //Запрашиваем ответ у сервера
  const products = await res.json() //Делаем формат json
  products.forEach(product => { //Для каждого добавляем элемента добавляем в лист и создаём карточку
    productList.appendChild(createCard(product));
  });
}

loadProducts();
