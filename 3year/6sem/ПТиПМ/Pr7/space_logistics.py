# Модуль склада (warehouse)
class WarehouseModule:
    """Складской модуль: хранит и резервирует грузы."""

    def __init__(self):
        # Имитация базы данных склада
        self.storage = {
            'food': {'total': 1000, 'reserved': 0},
            'water': {'total': 500, 'reserved': 0},
            'fuel': {'total': 2000, 'reserved': 0},
            'tools': {'total': 300, 'reserved': 0}
        }

    def reserve_cargo(self, cargo_type, quantity):
        """
        Резервирует указанное количество груза.
        Возвращает словарь с результатом: success (bool), message (str), reserved_quantity (int).
        """
        if cargo_type not in self.storage:
            return {'success': False, 'message': 'Неизвестный тип груза', 'reserved': 0}

        available = self.storage[cargo_type]['total'] - self.storage[cargo_type]['reserved']
        if available < quantity:
            return {'success': False, 'message': 'Недостаточно свободного груза', 'reserved': 0}

        self.storage[cargo_type]['reserved'] += quantity
        return {'success': True, 'message': 'Груз зарезервирован', 'reserved': quantity}

    def get_available(self, cargo_type):
        """Возвращает доступное (не зарезервированное) количество груза."""
        if cargo_type not in self.storage:
            return 0
        return self.storage[cargo_type]['total'] - self.storage[cargo_type]['reserved']


# Модуль доставки (delivery)
class DeliveryModule:
    """Модуль доставки: создаёт заказы на отправку грузов."""

    def __init__(self, warehouse):
        """
        :param warehouse: ссылка на объект WarehouseModule (интеграция через композицию).
        """
        self.warehouse = warehouse
        self.orders = []          # список созданных заказов
        self.order_counter = 0

    def create_order(self, destination, cargo_type, quantity):
        """
        Создаёт заказ на доставку груза.
        1. Проверяет доступность груза через склад.
        2. Если доступно, резервирует груз.
        3. Формирует заказ.
        Возвращает словарь с информацией о заказе или об ошибке.
        """
        # Шаг 1: проверить доступность
        available = self.warehouse.get_available(cargo_type)
        if available < quantity:
            return {'success': False, 'message': 'Недостаточно груза на складе'}

        # Шаг 2: зарезервировать на складе
        reserve_result = self.warehouse.reserve_cargo(cargo_type, quantity)
        if not reserve_result['success']:
            return {'success': False, 'message': 'Ошибка резервирования на складе'}

        # Шаг 3: создать заказ
        self.order_counter += 1
        order = {
            'order_id': self.order_counter,
            'destination': destination,
            'cargo_type': cargo_type,
            'quantity': reserve_result['reserved'],  # используем зарезервированное количество
            'status': 'CREATED'
        }
        self.orders.append(order)
        return {'success': True, 'order': order}

    def cancel_order(self, order_id):
        """Отменяет заказ и освобождает зарезервированный груз (не реализовано)."""
        pass