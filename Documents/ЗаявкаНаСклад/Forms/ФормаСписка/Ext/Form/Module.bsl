﻿&НаКлиенте
Процедура ОткрытьОтчетПоЗаявке(Команда)
	ТекСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;	
	КонецЕсли;	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияИспользования", ТекСтрока.Ссылка);
	ПараметрыФормы.Вставить("СформироватьПриОткрытии",     Истина);
	ПараметрыФормы.Вставить("Отбор",                       Новый Структура("Заявка", ТекСтрока.Ссылка));
	ПараметрыФормы.Вставить("Заявка",                     ТекСтрока.Ссылка);
		
	ОткрытьФорму("Отчет.ОтчетПоЗаявкамНаСклад.Форма",
		ПараметрыФормы,
		,
		"Заявка=" + ТекСтрока.Ссылка
	);

КонецПроцедуры
