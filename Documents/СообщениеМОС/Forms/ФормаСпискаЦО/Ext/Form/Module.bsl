﻿
&НаКлиенте
Перем ИмяАктивнойКнопки;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиСерверВызовСервера.ПолучитьОперацию("Открытие списка информационных сообщений");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	
	ТТПоАйпи = ПараметрыСеанса.ТорговаяТочкаПоАйпи;
	Ссылки = СсылкиНаДокументы();
	
	СписокСсылок = Новый СписокЗначений;
	СписокСсылок.ЗагрузитьЗначения(Ссылки);
	
	
	ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементОтбора.Использование = Истина;
	ЭлементОтбора.ПравоеЗначение = СписокСсылок;
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
	
	
	//ТекДата = ТекущаяДатаСеанса();
	//МассивРолейТекПользователя = МеханизмОбменаСообщениями.ПолучитьРолиПользователяИлиФизЛица(ПараметрыСеанса.ТекущийПользователь);
	//
	//ФизЛицоТекПользователя = ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
	//
	//РолиТекПользователя = Новый СписокЗначений;
	//
	//ЭтоАдминистратор = Ложь;
	//Если МассивРолейТекПользователя <> Неопределено Тогда
	//	РолиТекПользователя.ЗагрузитьЗначения(МассивРолейТекПользователя);
	//	Если МассивРолейТекПользователя.Найти(Справочники.РолиПользователей.Администратор) <> Неопределено Тогда
	//		ЭтоАдминистратор = Истина;
	//	КонецЕсли;
	//КонецЕсли;
	//
	////ОснРежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	//ОснРежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	//
	//ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = Ложь;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//Если ЭтоАдминистратор Тогда
	//	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	//Иначе
	//	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	//КонецЕсли;
	//
	//
	//ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаАктуальности");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = ТекДата;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	//Если ЭтоАдминистратор Тогда
	//	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	//Иначе
	//	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	//КонецЕсли;
	
	////+++AK GOLV
	//ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаДоставки");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = ТекДата;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	//Если ЭтоАдминистратор Тогда
	//	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	//Иначе
	//	ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	//КонецЕсли;	
	////---AK GOLV

	//ГруппаИЛИ1 = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	//ГруппаИЛИ1.Использование = Истина;
	//ГруппаИЛИ1.РежимОтображения = ОснРежимОтображения;
	//ГруппаИЛИ1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	////
	//ЭлементОтбора = ГруппаИЛИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Отправитель");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = РолиТекПользователя;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	//ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	////
	//ГруппаИ1 = ГруппаИЛИ1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	//ГруппаИ1.Использование = Истина;
	//ГруппаИ1.РежимОтображения = ОснРежимОтображения;
	//ГруппаИ1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	//	
	//ЭлементОтбора = ГруппаИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Проведен");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = Истина;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	//	
	//ЭлементОтбора = ГруппаИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РольПолучателя");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = РолиТекПользователя;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	//ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	
	////+++АК SHEP 20160504: отображаем, если наша роль в ТЧ "РолиПолучателей"
	//ЭлементОтбора = ГруппаИЛИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РолиПолучателей.Роль");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = РолиТекПользователя;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	//ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	////---АК SHEP 20160504
	//
	////+++АК Pans 20161020: отображаем также, если тек. пользователь есть в ТЧ ПрямыеПолучатели
	//ЭлементОтбора = ГруппаИЛИ1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПрямыеПолучатели.Получатель");
	//ЭлементОтбора.Использование = Истина;
	//ЭлементОтбора.ПравоеЗначение = ФизЛицоТекПользователя;
	//ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ЭлементОтбора.РежимОтображения = ОснРежимОтображения;
	////---АК Pans 20161020
	
	//Заголовок = Заголовок + МеханизмОбменаСообщениями.ПолучитьДобавкуКЗаголовкуОкна();
		
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыделитьКнопку("ФильтрВсеСообщения");
	ОбновитьДанныеНаСервере(ИмяАктивнойКнопки);
	
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс);
	
КонецПроцедуры


&НаКлиенте
Процедура ФильтрВсеСообщения(Команда)
	
	ВыделитьКнопку("ФильтрВсеСообщения");
	ОбновитьДанныеНаСервере(ИмяАктивнойКнопки);
	
КонецПроцедуры


&НаКлиенте
Процедура ФильтрНеОбработано(Команда)
	
	ВыделитьКнопку("ФильтрНеОбработано");
	ОбновитьДанныеНаСервере(ИмяАктивнойКнопки);
	
КонецПроцедуры


&НаКлиенте
Процедура ФильтрИнциденты(Команда)
	
	ВыделитьКнопку("ФильтрИнциденты");
	ОбновитьДанныеНаСервере(ИмяАктивнойКнопки);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьКнопку(ИмяКнопки)
	
	Для каждого Элемент Из Элементы Цикл
		Если Лев(Элемент.Имя, 6) = "Фильтр" Тогда
			Если Элемент.Имя = ИмяКнопки Тогда
				Элемент.Шрифт = Новый Шрифт(Элемент.Шрифт,,, Истина);
				ИмяАктивнойКнопки = ИмяКнопки;
			Иначе
				Элемент.Шрифт = Новый Шрифт(Элемент.Шрифт,,, Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры // ВыделитьКнопку()

Процедура ОбновитьДанныеНаСервере(ИмяАктивнойКнопки)
	
	Для каждого ЭО1 Из Список.Отбор.Элементы Цикл
		Если ЗначениеЗаполнено(ЭО1.Представление) И Лев(ЭО1.Представление + "      ", 6) = "Фильтр" Тогда
			Если ЭО1.Представление = ИмяАктивнойКнопки Тогда
				ЭО1.Использование = Истина;
			Иначе
				ЭО1.Использование = Ложь;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Если ПереходКФормеПодтверждения() Тогда
		Отказ = Истина;
		ДокСсылка = Элементы.Список.ТекущаяСтрока;
		СП1 = Новый Структура("ДокСсылка", ДокСсылка);
		ФормаПодтверждения = ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаПодтвержденияЦО", СП1, ЭтаФорма);
	КонецЕсли;
	
	
КонецПроцедуры

Функция ПереходКФормеПодтверждения()

	ТекущийПользователь = ПараметрыСеанса.ТекущийПользователь;
	
	Объект = Элементы.Список.ТекущаяСтрока;
	МассивРолей = Справочники.РолиПользователей.ПолучитьРолиПользователя(ТекущийПользователь);
	Если МассивРолей.Найти(Объект.Отправитель) = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
		
	Возврат Ложь;

КонецФункции // ()


&НаКлиенте
Процедура СоздатьИзШаблона(Команда)
	
	Форма1 = ПолучитьФорму("Справочник.ШаблоныСообщенийМОС.Форма.ФормаВыбора",, ЭтаФорма);
	ВыбранныйШаблон = Форма1.ОткрытьМодально();
	Если ВыбранныйШаблон = КодВозвратаДиалога.Отмена ИЛИ НЕ ЗначениеЗаполнено(ВыбранныйШаблон) Тогда
		Возврат;
	КонецЕсли;
	ПФ1 = Новый Структура("Шаблон", ВыбранныйШаблон);
	
	ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаСообщенияЦО", ПФ1, ЭтаФорма, "СЩ_НовоеСообщениеЦО");
			
КонецПроцедуры


&НаКлиенте
Процедура СоздатьПроизвольное(Команда)
	
	ПФ1 = Новый Структура();
	ОткрытьФорму("Документ.СообщениеМОС.Форма.ФормаСообщенияЦО", ПФ1, ЭтаФорма, "СЩ_НовоеСообщениеЦО");
			
КонецПроцедуры


&НаКлиенте
Процедура ФильтрВсеОтправленные(Команда)
	
	ВыделитьКнопку("ФильтрВсеОтправленные");
	ОбновитьДанныеНаСервере(ИмяАктивнойКнопки);
	
КонецПроцедуры


&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	// Вставить содержимое обработчика.
КонецПроцедуры

Функция СсылкиНаДокументы()

	ТекДата = ТекущаяДатаСеанса();
	РолиТекПользователя = МеханизмОбменаСообщениями.ПолучитьРолиПользователяИлиФизЛица(ПараметрыСеанса.ТекущийПользователь);
	ФизЛицоТекПользователя = ПараметрыСеанса.ТекущийПользователь.ФизЛицо;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СообщениеМОС.Ссылка
	|ИЗ
	|	Документ.СообщениеМОС КАК СообщениеМОС
	|ГДЕ
	|	СообщениеМОС.ПометкаУдаления = ЛОЖЬ
	|	И СообщениеМОС.ДатаАктуальности >= &ТекДата
	|	И СообщениеМОС.ДатаДоставки <= &ТекДата
	|	И (СообщениеМОС.Отправитель В (&РолиТекПользователя)
	|			ИЛИ СообщениеМОС.РольПолучателя В (&РолиТекПользователя)
	|				И СообщениеМОС.Проведен)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СообщениеМОСРолиПолучателей.Ссылка
	|ИЗ
	|	Документ.СообщениеМОС.РолиПолучателей КАК СообщениеМОСРолиПолучателей
	|ГДЕ
	|	СообщениеМОСРолиПолучателей.Ссылка.Проведен = ИСТИНА
	|	И СообщениеМОСРолиПолучателей.Ссылка.ДатаАктуальности >= &ТекДата
	|	И СообщениеМОСРолиПолучателей.Роль В(&РолиТекПользователя)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СообщениеМОСПрямыеПолучатели.Ссылка
	|ИЗ
	|	Документ.СообщениеМОС.ПрямыеПолучатели КАК СообщениеМОСПрямыеПолучатели
	|ГДЕ
	|	СообщениеМОСПрямыеПолучатели.Ссылка.Проведен = ИСТИНА
	|	И СообщениеМОСПрямыеПолучатели.Ссылка.ДатаАктуальности >= &ТекДата
	|	И СообщениеМОСПрямыеПолучатели.Получатель = &ФизЛицоТекПользователя";

	Запрос.УстановитьПараметр("ТекДата", ТекДата);
	Запрос.УстановитьПараметр("РолиТекПользователя", РолиТекПользователя);
	Запрос.УстановитьПараметр("ФизЛицоТекПользователя", ФизЛицоТекПользователя);
	
		
	Результат = Запрос.Выполнить();

	Ссылки = Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");

	Возврат Ссылки;

КонецФункции // ()
