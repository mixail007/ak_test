﻿Функция ПолучитьТабКатегорий(СкладВладелец) Экспорт
	ТЗКат=Новый ТаблицаЗначений;
	ТЗКат.Колонки.Добавить("Группа");
	ТЗКат.Колонки.Добавить("Склад");
	ТЗКат.Колонки.Добавить("Поиск");
	ТЗКат.Колонки.Добавить("ПоискДоп");
	ТЗКат.Колонки.Добавить("Неактивные");
	ТЗКат.Колонки.Добавить("ВСборке");
	ТЗКат.Колонки.Добавить("СборкаЗакончена");
	ТЗКат.Колонки.Добавить("НаДебаркадере");
	ТЗКат.Колонки.Добавить("НаДебаркадереВодительПринял");
	ТЗКат.Колонки.Добавить("ВодительПринял");
	ТЗКат.Колонки.Добавить("КоличествоПаллет");
	ТЗКат.Колонки.Добавить("Забыт");
	
	БГ=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("P00000243");
	Кав=Справочники.СтруктурныеЕдиницы.НайтиПоКоду("P00000231");
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Долгосрок";
	НовСтр.Поиск="Долгосро";
	НовСтр.ПоискДоп="";
	
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Заморозка";
	НовСтр.Поиск="Замороз";
	НовСтр.ПоискДоп="";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Овощи";
	НовСтр.Поиск="Овощи";
	НовСтр.ПоискДоп="";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Охлажден";
	НовСтр.Поиск="Охл";
	НовСтр.ПоискДоп="";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Хлеб";
	НовСтр.Поиск="Хлеб";
	НовСтр.ПоискДоп="";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Молочка";
	НовСтр.Поиск=?(Найти(Строка(СкладВладелец),"Кавказский")>0,"Кавказский","Молоч");
	НовСтр.ПоискДоп="";
	
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Штучный";
	НовСтр.Поиск="Штуч";
	НовСтр.ПоискДоп="Мелко";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Мелкошт";
	НовСтр.Поиск="Мелкошт";
	НовСтр.ПоискДоп="";
	НовСтр.Склад=Кав;
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Сухой";
	НовСтр.Поиск="Сухо";
	НовСтр.ПоискДоп="Штуч";
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Кондитер";
	НовСтр.Поиск="Кондитер";
	НовСтр.ПоискДоп="";
	НовСтр.Склад=БГ;
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Дневной";
	НовСтр.Поиск="Днев";
	НовСтр.ПоискДоп="";
	НовСтр.Склад=БГ;
	
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Забыт";
	НовСтр.Поиск="Забыт";
	НовСтр.ПоискДоп="";
	НовСтр.Склад=Кав;
	
	//+++АК LAGP 2018.04.14 Дежурство. Добавлено отображение движений Тилси
	НовСтр=ТЗКат.Добавить();
	НовСтр.Группа="Тилси";
	НовСтр.Поиск="Тилси";
	НовСтр.ПоискДоп="";
		//---АК LAGP
	Возврат ТЗКат;	

КонецФункции // ()
 

Функция СформироватьОтчет(ДатаНачала,ДатаОкончания,СкладВладелец,ОтборСтатусПаллетта="",КодОрганизации="", СписокВорот="") Экспорт
	Если ЗначениеЗаполнено(КодОрганизации) Тогда
		Организация=Справочники.Организации.НайтиПоКоду(КодОрганизации);
	Иначе	
		Организация=Справочники.Организации.ПустаяСсылка();
	КонецЕсли; 	
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Дата1",ДатаНачала);
	Запрос.УстановитьПараметр("Дата2",ДатаОкончания);
	Запрос.УстановитьПараметр("ПустойСтатус",Перечисления.СтатусыРасходныхОрдеров.ПустаяСсылка());
	Запрос.УстановитьПараметр("СтатусВСборке",Перечисления.СтатусПаллета.ВСборке);
	Запрос.УстановитьПараметр("НаДебаркадере",Перечисления.СтатусПаллета.НаДебаркадере);
	Запрос.УстановитьПараметр("ВодительПринял",Перечисления.СтатусПаллета.ВодительПринял);
	Запрос.УстановитьПараметр("СтатусСборкаЗакончена",Перечисления.СтатусПаллета.Собран);
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Вкусвилл", Справочники.Организации.НайтиПоКоду("000000006"));

	//++ХЖК 15.08.2018 ИП-00019563
	Запрос.УстановитьПараметр("СписокВорот", СписокВорот);
	//++ХЖК 15.08.2018 ИП-00019563
	
	Запрос.УстановитьПараметр("Владелец",СкладВладелец);
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|	СканированныеПаллетыСрезПоследних.КоличествоЗабыто КАК Паллет
		|ПОМЕСТИТЬ втЗабытые
		|ИЗ
		|	РегистрСведений.СканированныеПаллеты.СрезПоследних(&Дата2, ) КАК СканированныеПаллетыСрезПоследних
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Статус = &НаДебаркадере
		|	И СканированныеПаллетыСрезПоследних.КоличествоЗабыто > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Получатель КАК СтруктурнаяЕдиница,
		|	МаршрутныйЛистТорговыеТочки.ПоставкаВСетках КАК КолвоСетокВПоставке,
		|
		|	ВЫБОР
		|		КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ЕСТЬ NULL
		|				ИЛИ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту = НЕОПРЕДЕЛЕНО
		|			ТОГДА ВЫБОР
		|					КОГДА МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
		|						ТОГДА МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
		|					ИНАЧЕ МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
		|					ТОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
		|				ИНАЧЕ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту
		|			КОНЕЦ
		|	КОНЕЦ КАК ВремяВыходаВРейс,

		|	МаршрутныйЛистРасходныеОрдера.Документ.Комментарий КАК Примечание,
		|	МаршрутныйЛистРасходныеОрдера.Документ,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Сборщик КАК Сборщик,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад.Владелец,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад,
		|	МаршрутныйЛистРасходныеОрдера.Документ.КоличествоПаллет КАК КоличествоПаллет,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Статус КАК Статус,
		|	МаршрутныйЛистРасходныеОрдера.Документ.СборкаТерминаломЗакончена КАК СборкаТерминаломЗакончена,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Водитель КАК Водитель,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ПогрузкаНачата,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ДатаЗавершенияПогрузки,
		|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.Номер, МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.Наименование) КАК МаршрутНаименование,
		|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.НомерПоВремениВыезда, МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.НомерПоВремениВыезда) КАК МаршрутНомерПоВремениВыезда,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад.ДляШтучногоТовара КАК ДляШтучногоТовара,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ДатаПодачиМашины
		|ПОМЕСТИТЬ вт
		|ИЗ
		|	Документ.МаршрутныйЛист.РасходныеОрдера КАК МаршрутныйЛистРасходныеОрдера
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Маршруты.ТорговыеТочки КАК МаршрутныйЛистТорговыеТочки
		|		ПО МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут = МаршрутныйЛистТорговыеТочки.Ссылка
		|			И МаршрутныйЛистРасходныеОрдера.Документ.Получатель = МаршрутныйЛистТорговыеТочки.СтруктурнаяЕдиница
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НомераМаршрутов.СрезПоследних(ДобавитьКДате(&Дата2,День,-1), ) КАК НомераМаршрутовСрезПоследних
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АК_СоответствиеВоротМаршрутам.СрезПоследних(&Дата2,) КАК АК_СоответствиеВоротМаршрутамСрезПоследних
		|			ПО НомераМаршрутовСрезПоследних.Номер = АК_СоответствиеВоротМаршрутамСрезПоследних.НомерМаршрута
		|		ПО МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут = НомераМаршрутовСрезПоследних.Маршрут
		|ГДЕ
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И (ВЫБОР
		|				КОГДА МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.Организация = ЗНАЧЕНИЕ(Справочник.организации.ПустаяСсылка)
		|					ТОГДА &Вкусвилл
		|				ИНАЧЕ МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.Организация
		|			КОНЕЦ = &Организация
		|			ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
		|	И МаршрутныйЛистРасходныеОрдера.Ссылка.Проведен
		|	И МаршрутныйЛистРасходныеОрдера.Ссылка.Дата МЕЖДУ &Дата1 И &Дата2
		|	И МаршрутныйЛистРасходныеОрдера.Документ.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРасходныхОрдеров.Отменен)
		|	И МаршрутныйЛистРасходныеОрдера.Документ.Склад.Владелец = &Владелец
		|	И МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут <> ЗНАЧЕНИЕ(Справочник.Маршруты.ПустаяСсылка)
		//++АК hamz 25.09.2018 ИП-00019563
		|"+?(СписокВорот = "", "", "И АК_СоответствиеВоротМаршрутамСрезПоследних.Ворота.ИД В (&СписокВорот)") +"
		//--АК hamz 25.09.2018 ИП-00019563
		|СГРУППИРОВАТЬ ПО
		|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.Номер, МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.Наименование),
		|	МаршрутныйЛистРасходныеОрдера.Документ,
		|	ВЫБОР
		|		КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ЕСТЬ NULL
		|				ИЛИ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту = НЕОПРЕДЕЛЕНО
		|			ТОГДА ВЫБОР
		|					КОГДА МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
		|						ТОГДА МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
		|					ИНАЧЕ МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.ПланируемоеВремяВыездаПоМаршруту
		|				КОНЕЦ
		|		ИНАЧЕ ВЫБОР
		|				КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
		|					ТОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
		|				ИНАЧЕ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту
		|			КОНЕЦ
		|	КОНЕЦ,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка,
		|	МаршрутныйЛистТорговыеТочки.ПоставкаВСетках,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Получатель,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Комментарий,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Сборщик,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад.Владелец,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад,
		|	МаршрутныйЛистРасходныеОрдера.Документ.КоличествоПаллет,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Статус,
		|	МаршрутныйЛистРасходныеОрдера.Документ.СборкаТерминаломЗакончена,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.Водитель,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ПогрузкаНачата,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ДатаЗавершенияПогрузки,
		|	МаршрутныйЛистРасходныеОрдера.Документ.Склад.ДляШтучногоТовара,
		|	МаршрутныйЛистРасходныеОрдера.Ссылка.ДатаПодачиМашины,
		|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.НомерПоВремениВыезда, МаршрутныйЛистРасходныеОрдера.Ссылка.Маршрут.НомерПоВремениВыезда)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Маршрут,
		|	вт.СтруктурнаяЕдиница,
		|	вт.КолвоСетокВПоставке,
		|	вт.ВремяВыходаВРейс,
		|	вт.Примечание,
		|	вт.Документ,
		|	вт.Сборщик,
		|	вт.ДокументСкладВладелец,
		|	""Забыт"" КАК ДокументСклад,
		|	вт.КоличествоПаллет,
		|	вт.Статус,
		|	вт.СборкаТерминаломЗакончена,
		|	вт.Водитель,
		|	вт.ПогрузкаНачата,
		|	вт.ДатаЗавершенияПогрузки,
		|	вт.МаршрутНаименование,
		|	вт.МаршрутНомерПоВремениВыезда,
		|	вт.ДляШтучногоТовара,
		|	вт.ДатаПодачиМашины
		|ПОМЕСТИТЬ вт1
		|ИЗ
		|	вт КАК вт
		|ГДЕ
		|	вт.Документ В
		|			(ВЫБРАТЬ
		|				втЗабытые.ПаллетРасходныйОрдер
		|			ИЗ
		|				втЗабытые)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Маршрут,
		|	вт.СтруктурнаяЕдиница,
		|	вт.КолвоСетокВПоставке,
		|	вт.ВремяВыходаВРейс,
		|	вт.Примечание,
		|	вт.Документ,
		|	вт.Сборщик,
		|	вт.ДокументСкладВладелец,
		|	вт.ДокументСклад,
		|	вт.КоличествоПаллет,
		|	вт.Статус,
		|	вт.СборкаТерминаломЗакончена,
		|	вт.Водитель,
		|	вт.ПогрузкаНачата,
		|	вт.ДатаЗавершенияПогрузки,
		|	вт.МаршрутНаименование,
		|	вт.МаршрутНомерПоВремениВыезда,
		|	вт.ДляШтучногоТовара,
		|	вт.ДатаПодачиМашины
		|ПОМЕСТИТЬ вт2
		|ИЗ
		|	вт КАК вт
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	вт1.Маршрут,
		|	вт1.СтруктурнаяЕдиница,
		|	вт1.КолвоСетокВПоставке,
		|	вт1.ВремяВыходаВРейс,
		|	вт1.Примечание,
		|	вт1.Документ,
		|	вт1.Сборщик,
		|	вт1.ДокументСкладВладелец,
		|	вт1.ДокументСклад,
		|	вт1.КоличествоПаллет,
		|	вт1.Статус,
		|	вт1.СборкаТерминаломЗакончена,
		|	вт1.Водитель,
		|	вт1.ПогрузкаНачата,
		|	вт1.ДатаЗавершенияПогрузки,
		|	вт1.МаршрутНаименование,
		|	вт1.МаршрутНомерПоВремениВыезда,
		|	вт1.ДляШтучногоТовара,
		|	вт1.ДатаПодачиМашины
		|ИЗ
		|	вт1 КАК вт1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоставПаллеты.Ссылка) КАК КоличествоПаллет,
		|	СоставПаллеты.РасходныйОрдер
		|ПОМЕСТИТЬ втПаллеты
		|ИЗ
		|	Справочник.СоставПаллеты КАК СоставПаллеты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ вт КАК вт
		|		ПО СоставПаллеты.РасходныйОрдер = вт.Документ
		|ГДЕ
		|	СоставПаллеты.ПометкаУдаления = ЛОЖЬ
		|
		|СГРУППИРОВАТЬ ПО
		|	СоставПаллеты.РасходныйОрдер
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Документ,
		|	вт.КоличествоПаллет
		|ПОМЕСТИТЬ втНеактивные
		|ИЗ
		|	вт КАК вт
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СканированныеПаллеты КАК СканированныеПаллеты
		|		ПО (СканированныеПаллеты.Ордер = вт.Документ)
		|ГДЕ
		|	СканированныеПаллеты.Ордер ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Документ,
		|	вт.КоличествоПаллет
		|ПОМЕСТИТЬ втВСборке
		|ИЗ
		|	вт КАК вт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СканированныеПаллеты.СрезПоследних(
		|				&Дата2,
		|				Ордер В
		|					(ВЫБРАТЬ
		|						вт.Документ
		|					ИЗ
		|						вт)) КАК СканированныеПаллеты
		|		ПО (СканированныеПаллеты.Ордер = вт.Документ)
		|ГДЕ
		|	СканированныеПаллеты.Статус = &СтатусВСборке
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|	СканированныеПаллетыСрезПоследних.Количество КАК Паллет
		|ПОМЕСТИТЬ втВодительПринял
		|ИЗ
		|	РегистрСведений.СканированныеПаллеты.СрезПоследних(
		|			&Дата2,
		|			Паллет.РасходныйОрдер В
		|				(ВЫБРАТЬ
		|					вт.Документ
		|				ИЗ
		|					вт)) КАК СканированныеПаллетыСрезПоследних
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Статус = &ВодительПринял
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|	СканированныеПаллетыСрезПоследних.Количество КАК Паллет
		|ПОМЕСТИТЬ втНаДебаркадере
		|ИЗ
		|	РегистрСведений.СканированныеПаллеты.СрезПоследних(
		|			&Дата2,
		|			Паллет.РасходныйОрдер В
		|				(ВЫБРАТЬ
		|					вт.Документ
		|				ИЗ
		|					вт)) КАК СканированныеПаллетыСрезПоследних
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Статус = &НаДебаркадере
		
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|	СканированныеПаллетыСрезПоследних.КоличествоЗабыто КАК Паллет
		|ПОМЕСТИТЬ втЗабытыеИтог
		|ИЗ
		|	РегистрСведений.СканированныеПаллеты.СрезПоследних(
		|			&Дата2,
		|			Паллет.РасходныйОрдер В
		|				(ВЫБРАТЬ
		|					вт.Документ
		|				ИЗ
		|					вт)) КАК СканированныеПаллетыСрезПоследних
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Статус = &НаДебаркадере И СканированныеПаллетыСрезПоследних.КоличествоЗабыто>0
		
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|	СканированныеПаллетыСрезПоследних.Количество КАК Паллет
		|ПОМЕСТИТЬ втНаДебаркадереВодительПринял
		|ИЗ
		|	РегистрСведений.СканированныеПаллеты КАК СканированныеПаллетыСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер КАК ПаллетРасходныйОрдер,
		|			СканированныеПаллетыСрезПоследних.Паллет КАК Паллет,
		|			МАКСИМУМ(СканированныеПаллетыСрезПоследних.Период) КАК Период
		|		ИЗ
		|			РегистрСведений.СканированныеПаллеты КАК СканированныеПаллетыСрезПоследних
		|		ГДЕ
		|			СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер В
		|					(ВЫБРАТЬ
		|						вт.Документ
		|					ИЗ
		|						вт)
		|			И СканированныеПаллетыСрезПоследних.Статус = &НаДебаркадере
		|		
		|		СГРУППИРОВАТЬ ПО
		|			СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер,
		|			СканированныеПаллетыСрезПоследних.Паллет) КАК СканированныеПаллетыСрезПоследнихПосл
		|		ПО СканированныеПаллетыСрезПоследних.Паллет = СканированныеПаллетыСрезПоследнихПосл.Паллет
		|			И СканированныеПаллетыСрезПоследних.Период = СканированныеПаллетыСрезПоследнихПосл.Период
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Паллет.РасходныйОрдер В
		|			(ВЫБРАТЬ
		|				вт.Документ
		|			ИЗ
		|				вт)
		|	И СканированныеПаллетыСрезПоследних.Статус = &НаДебаркадере
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Документ,
		|	вт.КоличествоПаллет
		|ПОМЕСТИТЬ втСборкаЗакончена
		|ИЗ
		|	вт КАК вт
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СканированныеПаллеты КАК СканированныеПаллетыСрезПоследних
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|				СканированныеПаллетыСрезПоследних.Ордер КАК ПаллетРасходныйОрдер,
		|				МАКСИМУМ(СканированныеПаллетыСрезПоследних.Период) КАК Период
		|			ИЗ
		|				РегистрСведений.СканированныеПаллеты КАК СканированныеПаллетыСрезПоследних
		|			ГДЕ
		|				СканированныеПаллетыСрезПоследних.Ордер В
		|						(ВЫБРАТЬ
		|							вт.Документ
		|						ИЗ
		|							вт)
		|				И СканированныеПаллетыСрезПоследних.Статус = &СтатусСборкаЗакончена
		|			
		|			СГРУППИРОВАТЬ ПО
		|				СканированныеПаллетыСрезПоследних.Ордер,
		|				СканированныеПаллетыСрезПоследних.Паллет) КАК СканированныеПаллетыСрезПоследнихПосл
		|			ПО СканированныеПаллетыСрезПоследних.Ордер = СканированныеПаллетыСрезПоследнихПосл.ПаллетРасходныйОрдер
		|				И СканированныеПаллетыСрезПоследних.Период = СканированныеПаллетыСрезПоследнихПосл.Период
		|		ПО (СканированныеПаллетыСрезПоследних.Ордер = вт.Документ)
		|ГДЕ
		|	СканированныеПаллетыСрезПоследних.Ордер В
		|			(ВЫБРАТЬ
		|				вт.Документ
		|			ИЗ
		|				вт)
		|	И СканированныеПаллетыСрезПоследних.Статус = &СтатусСборкаЗакончена
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	вт.Маршрут КАК Маршрут,
		|	вт.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
		|	вт.Сборщик,
		|	СУММА(ЕСТЬNULL(втНеактивные.КоличествоПаллет, NULL)) КАК Неактивные,
		|	СУММА(ЕСТЬNULL(втВСборке.КоличествоПаллет, NULL)) КАК ВСборке,
		|	СУММА(ЕСТЬNULL(втСборкаЗакончена.КоличествоПаллет,  Выбор когда вт.КоличествоПаллет=0 тогда null иначе вт.КоличествоПаллет конец)) КАК СборкаЗакончена,
		|	СУММА(ЕСТЬNULL(втНаДебаркадере.Паллет,null)) КАК НаДебаркадере,
		|	СУММА(ЕСТЬNULL(втВодительПринял.Паллет, NULL)) КАК ВодительПринял,
		|	СУММА(ЕСТЬNULL(втНаДебаркадереВодительПринял.Паллет, NULL)) КАК НаДебаркадереВодительПринял,
		|	СУММА(ЕСТЬNULL(ЗабытыеИтог.Паллет, NULL)) КАК Забыт,
		|	МАКСИМУМ(вт.КолвоСетокВПоставке) КАК Сетки,
		|	вт.ВремяВыходаВРейс,
		|	ВЫБОР
		|		КОГДА вт.Маршрут.Наименование = ""0""
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 23, 59, 59)
		|		ИНАЧЕ вт.ВремяВыходаВРейс
		|	КОНЕЦ КАК ВремяВыходаВРейс1,
		|	вт.Водитель КАК Водитель,
		|	МАКСИМУМ(вт.ПогрузкаНачата) КАК ПогрузкаНачата,
		|	МИНИМУМ(вт.ДатаЗавершенияПогрузки) КАК ДатаЗавершенияПогрузки,
		|	вт.МаршрутНаименование КАК МаршрутНаименование,
		|	вт.МаршрутНомерПоВремениВыезда КАК МаршрутНомерПоВремениВыезда,
		|	вт.ДляШтучногоТовара,
		|	СУММА(вт.Документ.КоличествоПаллет) КАК КоличествоПаллет,
		|	МИНИМУМ(вт.ДатаПодачиМашины) КАК ДатаПодачиМашины,
		|	вт.ДокументСклад Склад
		|ИЗ
		|	вт2 КАК вт
		|		ЛЕВОЕ СОЕДИНЕНИЕ втНеактивные КАК втНеактивные
		|		ПО вт.Документ = втНеактивные.Документ
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВСборке КАК втВСборке
		|		ПО вт.Документ = втВСборке.Документ
		|		ЛЕВОЕ СОЕДИНЕНИЕ втСборкаЗакончена КАК втСборкаЗакончена
		|		ПО вт.Документ = втСборкаЗакончена.Документ
		|		ЛЕВОЕ СОЕДИНЕНИЕ втНаДебаркадере КАК втНаДебаркадере
		|		ПО вт.Документ = втНаДебаркадере.ПаллетРасходныйОрдер
		|		ЛЕВОЕ СОЕДИНЕНИЕ втВодительПринял КАК втВодительПринял
		|		ПО вт.Документ = втВодительПринял.ПаллетРасходныйОрдер
		|		ЛЕВОЕ СОЕДИНЕНИЕ втНаДебаркадереВодительПринял КАК втНаДебаркадереВодительПринял
		|		ПО вт.Документ = втНаДебаркадереВодительПринял.ПаллетРасходныйОрдер
		|		ЛЕВОЕ СОЕДИНЕНИЕ втЗабытыеИтог КАК ЗабытыеИтог
		|		ПО вт.Документ = ЗабытыеИтог.ПаллетРасходныйОрдер
		|СГРУППИРОВАТЬ ПО
		|	вт.Маршрут,
		|	вт.СтруктурнаяЕдиница,
		|	вт.Сборщик,
		|	вт.ВремяВыходаВРейс,
		|	ВЫБОР
		|		КОГДА вт.Маршрут.Наименование = ""0""
		|			ТОГДА ДАТАВРЕМЯ(1, 1, 1, 23, 59, 59)
		|		ИНАЧЕ вт.ВремяВыходаВРейс
		|	КОНЕЦ,
		|	вт.Водитель,
		|	вт.МаршрутНаименование,
		|	вт.МаршрутНомерПоВремениВыезда,
		|	вт.ДляШтучногоТовара,
		|	вт.ДокументСклад
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВремяВыходаВРейс1,
		|	вт.ВремяВыходаВРейс,
		|	МаршрутНомерПоВремениВыезда,
		|	МаршрутНаименование,
		|	СтруктурнаяЕдиница
		|ИТОГИ ПО
		|	Маршрут,
		|	СтруктурнаяЕдиница";
		ВыбМарш=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		
		                                                        
		ТЗКат=ПолучитьТабКатегорий(СкладВладелец);		
		ТабРез=Новый ТаблицаЗначений;
		ТабРез.Колонки.Добавить("Номер");
		ТабРез.Колонки.Добавить("Маршрут");
		ТабРез.Колонки.Добавить("Магазин");
		ТабРез.Колонки.Добавить("ВремяВыхода");
		ТабРез.Колонки.Добавить("ДатаПодачиМашины");
		ТабРез.Колонки.Добавить("ФактВремя");
		ТабРез.Колонки.Добавить("Водитель");
		ТабРез.Колонки.Добавить("Долгосрок");
		ТабРез.Колонки.Добавить("Заморозка");
		ТабРез.Колонки.Добавить("Овощи");
		ТабРез.Колонки.Добавить("Охлажден");
		ТабРез.Колонки.Добавить("Хлеб");
		ТабРез.Колонки.Добавить("Молочка");
		ТабРез.Колонки.Добавить("Штучный");
		ТабРез.Колонки.Добавить("Мелкошт");
		ТабРез.Колонки.Добавить("Сухой");
		ТабРез.Колонки.Добавить("Забыт");
		
		ТабРез.Колонки.Добавить("ДолгосрокСтатус");
		ТабРез.Колонки.Добавить("ЗаморозкаСтатус");
		ТабРез.Колонки.Добавить("ОвощиСтатус");
		ТабРез.Колонки.Добавить("ОхлажденСтатус");
		ТабРез.Колонки.Добавить("ХлебСтатус");
		ТабРез.Колонки.Добавить("МолочкаСтатус");
		ТабРез.Колонки.Добавить("ШтучныйСтатус");
		ТабРез.Колонки.Добавить("МелкоштСтатус");
		ТабРез.Колонки.Добавить("СухойСтатус");
		ТабРез.Колонки.Добавить("Сетки");
		ТабРез.Колонки.Добавить("МаршрутСтатус");
		ТабРез.Колонки.Добавить("МагазинСтатус");
		ТабРез.Колонки.Добавить("МаршрутДоп");
		ТабРез.Колонки.Добавить("Наименование");
		ТабРез.Колонки.Добавить("ПолноеНаименование");
		ТабРез.Колонки.Добавить("Тилси");      //+++АК LAGP 2018.04.14 Дежурство. Добавлено отображение движений Тилси
		ТабРез.Колонки.Добавить("ТилсиСтатус");

		ТабРез.Колонки.Добавить("Дневной");    
		ТабРез.Колонки.Добавить("ДневнойСтатус");
		ТабРез.Колонки.Добавить("Кондитер");    
		ТабРез.Колонки.Добавить("КондитерСтатус");
		ТабРез.Колонки.Добавить("ЗабытСтатус");
		
		//Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Маршруты.Ссылка,
			|	ВЫБОР
			|		КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ЕСТЬ NULL
			|				ИЛИ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту = НЕОПРЕДЕЛЕНО
			|			ТОГДА ВЫБОР
			|					КОГДА Маршруты.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
			|						ТОГДА Маршруты.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
			|					ИНАЧЕ Маршруты.ПланируемоеВремяВыездаПоМаршруту
			|				КОНЕЦ
			|		ИНАЧЕ ВЫБОР
			|				КОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту ССЫЛКА Справочник.ВремяВыездаПоМаршруту
			|					ТОГДА НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту.ВремяВыезда
			|				ИНАЧЕ НомераМаршрутовСрезПоследних.ПланируемоеВремяВыездаПоМаршруту
			|			КОНЕЦ
			|	КОНЕЦ КАК ВремяВыходаВРейс,

			|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.Номер, Маршруты.Наименование) КАК МаршрутНаименование,
			|	ЕСТЬNULL(НомераМаршрутовСрезПоследних.НомерПоВремениВыезда, Маршруты.НомерПоВремениВыезда) КАК МаршрутНомерПоВремениВыезда,
			|	Маршруты.ПолноеНаименование
			|ИЗ
			|	Справочник.Маршруты КАК Маршруты
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НомераМаршрутов.СрезПоследних(ДобавитьКДате(&Дата2,День,-1), ) КАК НомераМаршрутовСрезПоследних
			|		ПО Маршруты.Ссылка = НомераМаршрутовСрезПоследних.Маршрут";

		Результат = Запрос.Выполнить();

		ТЗМаршруты = Результат.Выгрузить();

		
		
		Ит=0;
		Пока ВыбМарш.Следующий() Цикл
			//ОблСтрокаНачало.Параметры.Маршрут=ВыбМарш.Маршрут;
			Ит=Ит+1;
			//ОблСтрокаНачало.Параметры.Номер=Ит;
			Сч=0;
			СтрокаРез=ТабРез.Добавить();
			ВыбТТ=ВыбМарш.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыбТТ.Следующий() Цикл
				Сч=Сч+1;
				ТЗКат=ПолучитьТабКатегорий(СкладВладелец);		

				
				//ОблСтрокаНачало.Параметры.ТТ=ВыбТТ.СтруктурнаяЕдиница;
				ВыбДетали=ВыбТТ.Выбрать();
				Водитель=Неопределено;
				Сетки=Ложь;
				ВремяВыхода=Дата(1,1,1);
				Пока ВыбДетали.Следующий() Цикл
					Для каждого Стр Из ТЗКат Цикл
						Если Найти(Нрег(Строка(ВыбДетали.Склад)),Нрег(Стр.Поиск))>0 И 
							(ЗначениеЗаполнено(Стр.ПоискДоп) И Найти(Нрег(Строка(ВыбДетали.Склад)),Нрег(Стр.ПоискДоп))=0 ИЛИ НЕ ЗначениеЗаполнено(Стр.ПоискДоп)) Тогда
							СумВыб=?(ВыбДетали.Неактивные=null,0,ВыбДетали.Неактивные);
							СумСтр=?(Стр.Неактивные=Неопределено,0,Стр.Неактивные);
							Стр.Неактивные=?(Стр.Неактивные=Неопределено и ВыбДетали.Неактивные=null,Неопределено, СумВыб+СумСтр);
							
							
							СумВыб=?(ВыбДетали.ВСборке=null,0,ВыбДетали.ВСборке);
							СумСтр=?(Стр.ВСборке=Неопределено,0,Стр.ВСборке);
							Стр.ВСборке=?(Стр.ВСборке=Неопределено и ВыбДетали.ВСборке=null,Неопределено, СумВыб+СумСтр);
							
							
							СумВыб=?(ВыбДетали.СборкаЗакончена=null,0,ВыбДетали.СборкаЗакончена);
							СумСтр=?(Стр.СборкаЗакончена=Неопределено,0,Стр.СборкаЗакончена);
							Стр.СборкаЗакончена=?(Стр.СборкаЗакончена=Неопределено и ВыбДетали.СборкаЗакончена=null,Неопределено, СумВыб+СумСтр);
							
							
							СумВыб=?(ВыбДетали.НаДебаркадере=null,0,ВыбДетали.НаДебаркадере);
							СумСтр=?(Стр.НаДебаркадере=Неопределено,0,Стр.НаДебаркадере);
							Стр.НаДебаркадере=?(Стр.НаДебаркадере=Неопределено и ВыбДетали.НаДебаркадере=null,Неопределено, СумВыб+СумСтр);
							
							
							СумВыб=?(ВыбДетали.ВодительПринял=null,0,ВыбДетали.ВодительПринял);
							СумСтр=?(Стр.ВодительПринял=Неопределено,0,Стр.ВодительПринял);
							Стр.ВодительПринял=?(Стр.ВодительПринял=Неопределено и ВыбДетали.ВодительПринял=null,Неопределено, СумВыб+СумСтр);
							
							СумВыб=?(ВыбДетали.НаДебаркадереВодительПринял=null,0,ВыбДетали.НаДебаркадереВодительПринял);
							СумСтр=?(Стр.НаДебаркадереВодительПринял=Неопределено,0,Стр.НаДебаркадереВодительПринял);
							Стр.НаДебаркадереВодительПринял=?(Стр.НаДебаркадереВодительПринял=Неопределено и ВыбДетали.НаДебаркадереВодительПринял=null,Неопределено, СумВыб+СумСтр);
							
							СумВыб=?(ВыбДетали.КоличествоПаллет=null,0,ВыбДетали.КоличествоПаллет);
							СумСтр=?(Стр.КоличествоПаллет=Неопределено,0,Стр.КоличествоПаллет);
							Стр.КоличествоПаллет=?(Стр.КоличествоПаллет=Неопределено и ВыбДетали.КоличествоПаллет=null,Неопределено, СумВыб+СумСтр);
							
							СумВыб=?(ВыбДетали.Забыт=null,0,ВыбДетали.Забыт);
							СумСтр=?(Стр.Забыт=Неопределено,0,Стр.Забыт);
							Стр.Забыт=?(Стр.Забыт=Неопределено и ВыбДетали.Забыт=null,Неопределено, СумВыб+СумСтр);
						КонецЕсли; 
						Водитель=ВыбДетали.Водитель;
						Если ВыбДетали.Сетки<>NULL Тогда
							Сетки=ВыбДетали.Сетки;
						КонецЕсли; 
						ВремяВыхода=ВыбДетали.ВремяВыходаВРейс;
						
					КонецЦикла; 
				КонецЦикла;
				
				СтрокаРез=ТабРез.Добавить();
				
				СтрМарш=ТЗМаршруты.НайтиСтроки(Новый Структура("Ссылка",ВыбМарш.Маршрут))[0];
				МаршПолноеНаименование=СтрМарш.ПолноеНаименование;
				Если Сч=1 Тогда
					СтрокаРез.Номер=?(ЗначениеЗаполнено(МаршПолноеНаименование),Строка(СтрМарш.МаршрутНаименование),Ит);
					СтрокаРез.Маршрут=Строка(?(ЗначениеЗаполнено(МаршПолноеНаименование),МаршПолноеНаименование,Строка(ВыбМарш.Маршрут)));
					
					Если ВыбМарш.ПогрузкаНачата=Истина и ВыбМарш.ДатаЗавершенияПогрузки>Дата(1,1,1) Тогда
						СтрокаРез.МаршрутСтатус=2;
					ИначеЕсли ВыбМарш.ПогрузкаНачата=Истина  Тогда
						СтрокаРез.МаршрутСтатус=1;
					Иначе                                                       
						СтрокаРез.МаршрутСтатус=0;                                              
					КонецЕсли; 
				КонецЕсли;
				СтрокаРез.ФактВремя=(ВыбМарш.ДатаЗавершенияПогрузки);
				СтрокаРез.ДатаПодачиМашины=(ВыбМарш.ДатаПодачиМашины);
				СтрокаРез.ПолноеНаименование=МаршПолноеНаименование;
				СтрокаРез.Наименование=Строка(ВыбМарш.Маршрут);
				СтрокаРез.МаршрутДоп=Строка(?(ЗначениеЗаполнено(МаршПолноеНаименование),МаршПолноеНаименование,Строка(ВыбМарш.Маршрут)));
				
				СтрокаРез.Водитель=Строка(Водитель);
				СтрокаРез.ВремяВыхода=ВремяВыхода;
				СтрокаРез.Сетки=Сетки;
				СтрокаРез.Магазин=Строка(ВыбТТ.СтруктурнаяЕдиница);
								
				ВсеПогружено=Ложь;
				УдалитьСтроку=Истина;
				Для каждого Стр Из ТЗКат Цикл
					Кол=0;
					Статус=0;
					//ОблВывод=ОблСтрокаКатегория;
					Если Стр.ВодительПринял=Неопределено Тогда
						Если Стр.НаДебаркадере=Неопределено Тогда
							Если Стр.СборкаЗакончена=Неопределено Тогда
								Если Стр.ВСборке=Неопределено Тогда
									Кол=Стр.Неактивные;
									Если Стр.Неактивные=Неопределено Тогда
									Иначе
										ВсеПогружено=Ложь;
									КонецЕсли; 
								Иначе
									Кол=Стр.ВСборке;
									ВсеПогружено=Ложь;
									Статус=1;
									//ОблВывод=ОблСтрокаКатегорияВСборке;
								КонецЕсли;
							Иначе
								Кол=Стр.СборкаЗакончена;
								Статус=2;
								ВсеПогружено=Ложь;
								//ОблВывод=ОблСтрокаКатегорияСобран;
							КонецЕсли;
						Иначе
							Если Стр.Группа="Забыт" Тогда
								Кол=Строка(Стр.Забыт);	
								ВсеПогружено=Ложь;
							Иначе
								Кол=Строка(Стр.СборкаЗакончена)+"/"+Стр.НаДебаркадере;
								Статус=?(Стр.СборкаЗакончена=Стр.НаДебаркадере, 3,2);
								Если Стр.Группа="Штучный" Тогда
									Кол=Строка(Стр.КоличествоПаллет);
									Статус=3;
								КонецЕсли; 
								ВсеПогружено=Ложь;
									
							
							КонецЕсли; 
						КонецЕсли;
					Иначе
						Кол=Строка(Стр.НаДебаркадереВодительПринял)+"/"+Стр.ВодительПринял;
						Статус=?(Стр.НаДебаркадереВодительПринял=Стр.ВодительПринял, 4,3);
						ВсеПогружено=?(Стр.НаДебаркадереВодительПринял=Стр.ВодительПринял, Истина,Ложь);
						Если Стр.Группа="Штучный" Тогда
							Кол=Строка(Стр.КоличествоПаллет);
							Статус=4;
							ВсеПогружено=Истина;
						КонецЕсли; 
					КонецЕсли; 
					СтрокаРез[Стр.Группа]=?(Кол=0,"",Строка(Кол));
					СтрокаРез[Стр.Группа+"Статус"]=Статус;
					//ОблВывод.Параметры.Количество=Кол;
					//ТабДок.Присоединить(ОблВывод);
					Если ЗначениеЗаполнено(ОтборСтатусПаллетта) Тогда
						Если ОтборСтатусПаллетта="ВСборке" Тогда
							ЧислоСтатус=1;
						ИначеЕсли ОтборСтатусПаллетта="Собран" Тогда
							ЧислоСтатус=2;
						ИначеЕсли ОтборСтатусПаллетта="НаДебаркадере" Тогда
							ЧислоСтатус=3;
						ИначеЕсли ОтборСтатусПаллетта="ВодительПринял" Тогда
							ЧислоСтатус=4;
						КонецЕсли; 						
					КонецЕсли; 
				    Если ЧислоСтатус=Статус и УдалитьСтроку Тогда
						УдалитьСтроку=Ложь;
					КонецЕсли; 
				КонецЦикла;
				СтрокаРез.МагазинСтатус=?(ВсеПогружено=Истина,1,0);

				Если ЗначениеЗаполнено(ОтборСтатусПаллетта) Тогда
					Если УдалитьСтроку Тогда
						Если ТабРез.Количество()>1 Тогда
							Если Не ЗначениеЗаполнено(ТабРез[ТабРез.Индекс(СтрокаРез)-1].Магазин) Тогда
								ТабРез.Удалить(ТабРез.Индекс(СтрокаРез)-1);    
							КонецЕсли;
						КонецЕсли; 
						ТабРез.Удалить(СтрокаРез);
					Иначе
						Если ТабРез.Индекс(СтрокаРез)=0 Тогда
							ПустСтрока=ТабРез.Вставить(ТабРез.Индекс(СтрокаРез));
							//СтрокаРез.Маршрут=ВыбМарш.Маршрут;
						Иначе
							Если ЗначениеЗаполнено(ТабРез[ТабРез.Индекс(СтрокаРез)-1].Магазин) и ТабРез[ТабРез.Индекс(СтрокаРез)-1].МаршрутДоп<>ТабРез[ТабРез.Индекс(СтрокаРез)].МаршрутДоп Тогда
								ПустСтрока=ТабРез.Вставить(ТабРез.Индекс(СтрокаРез));
							КонецЕсли;
							//СтрокаРез.Маршрут=ВыбМарш.Маршрут;
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
				//ТабДок.Вывести(ОблПустНачало);
				//Для каждого Стр Из ТЗКат Цикл
				//	ТабДок.Присоединить(ОблПустКатегория);
				//КонецЦикла; 
				//ТабДок.Присоединить(ОблПустКонец);
			КонецЦикла; 
		КонецЦикла;
		Ит=0;
		Марш=Неопределено;
		Для каждого Стр Из ТабРез Цикл
			Если Марш<>Стр.МаршрутДоп и ЗначениеЗаполнено(Стр.Магазин) Тогда
				//Марш=Стр.МаршрутДоп;
				Марш=Строка(?(ЗначениеЗаполнено(Стр.ПолноеНаименование),Стр.ПолноеНаименование,Стр.Наименование));
				Ит=Ит+1;
				//Стр.Номер=Ит;
				Стр.Номер=?(ЗначениеЗаполнено(Стр.ПолноеНаименование),Стр.Наименование,Ит);
				Стр.Маршрут=Марш;
			КонецЕсли;  
		КонецЦикла; 

		
		//ТабДок.ФиксацияСверху=1;
	   	Возврат ТабРез;

КонецФункции  