﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

Процедура ПередЗаписью(Отказ, Замещение)
	
	//Запись данных в Журнал изменений (Удаление)
	СтруктураОтбор = Новый Структура;
	Для Каждого ЭлементОтбор Из ЭтотОбъект.Отбор Цикл
		Если ЭлементОтбор.Использование Тогда
			СтруктураОтбор.Вставить(ЭлементОтбор.Имя, ЭлементОтбор.Значение);
		КонецЕсли;	
	КонецЦикла;
	
	Если СтруктураОтбор.Количество() > 0 Тогда
		
		Запрос = Новый Запрос;
		ТекстЗапроса =
		"ВЫБРАТЬ * ИЗ РегистрСведений." + ЭтотОбъект.Метаданные().Имя + " КАК Таб
		|ГДЕ
		|	ИСТИНА";
		
		Для Каждого ЭлементОтбор Из СтруктураОтбор Цикл
			ТекстЗапроса = ТекстЗапроса + Символы.ПС + "И " + ЭлементОтбор.Ключ + " = &Параметр" + ЭлементОтбор.Ключ;
			Запрос.УстановитьПараметр("Параметр" + ЭлементОтбор.Ключ, ЭлементОтбор.Значение);
		КонецЦикла;	
		
		Запрос.Текст = ТекстЗапроса;
		
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Выборка = Результат.Выбрать();
			Пока Выборка.Следующий() Цикл
				ДобавитьЗаписьЖурналИзменений(Выборка, "Тилси", "Удаление");
			КонецЦикла;	
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	//Запись данных в Журнал изменений (Добавление)
	Для Каждого ЗаписьНабора Из ЭтотОбъект Цикл
		ДобавитьЗаписьЖурналИзменений(ЗаписьНабора, "Тилси", "Добавление", 1);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Добавление записи в журнал изменений табелей
//
// Параметры:
//  Выборка       - <Тип.Выборка> - Выборка регистра Табель учета  
//  ТипТабеля     - <Тип.Строка> - Тип таблеля 
//  ТипДействия   - <Тип.Строка> - Тип действия (Добавление, Удаление)
//  Корректировка - <Тип.Число>  - Корректировка в секундах (используется для перезаписи сотрудника на дату/время)
//                                 
Процедура ДобавитьЗаписьЖурналИзменений(Выборка, ТипТабеля, ТипДействия, Корректировка = 0)
	
	Запись = РегистрыСведений.ЖурналИзмененияТабелей.СоздатьМенеджерЗаписи();
	
	ЗаполнитьЗначенияСвойств(Запись, Выборка);
	
	Запись.Период 			= ТекущаяДата() + Корректировка;
	Запись.ДатаТабеля 		= Выборка.Период;
	Запись.АвторИзменений 	= ПараметрыСеанса.ТекущийПользователь;
	Запись.ТипДействия 		= ТипДействия;
	Запись.ТипТабеля 		= ТипТабеля;
	Попытка
		Если ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПродавец) Тогда
			Запись.ИзмененияСделаныСМагазина = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
		КонецЕсли;	
	Исключение
	КонецПопытки;
	
	Запись.Записать();	
	
КонецПроцедуры