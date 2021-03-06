﻿
&НаКлиенте
Процедура Перенести(Команда)
	
	//
	ВладелецФормы.Объект.Товары.Очистить();
	Для Каждого СтрокаТЧ Из Товары Цикл 
		
		//
		Если НЕ СтрокаТЧ.Перенести Тогда
			Продолжить;
		КонецЕсли;	
		
		//
		НоваяСтрока = ВладелецФормы.Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
		
		//
		НоваяСтрока.ЗаявкаНаПроизводствоПерсональнойУпаковки = СтрокаТЧ.Заявка;
		Если НЕ ЗначениеЗаполнено(НоваяСтрока.ЗаявкаНаПроизводствоПерсональнойУпаковки) Тогда
			НоваяСтрока.ЗаявкаНаПроизводствоПерсональнойУпаковки = ВладелецФормы.Объект.Основание;	
		КонецЕсли;
		
	КонецЦикла;
	
	//
	ВладелецФормы.ЗаполнитьПризнакИспользованияХарактеристики();
	
	//
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура БРЕД_ЗаполнитьПоЗаявкамПоставщикаСервер(Ссылка, Поставщик)
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗаявкаНаПечатьЭтикеткиЭтикетки.Этикетка КАК Номенклатура,
	|	ЗаявкаНаПечатьЭтикеткиЭтикетки.КоличествоЗаказано КАК Заказано,
	|	ЗаявкаНаПечатьЭтикеткиЭтикетки.Этикетка.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	|	ЕСТЬNULL(АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.КоличествоПриход, 0) КАК Пришло,
	|	ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка
	|ПОМЕСТИТЬ ВТ_Предварительно
	|ИЗ
	|	Документ.ЗаявкаНаПечатьЭтикетки.Этикетки КАК ЗаявкаНаПечатьЭтикеткиЭтикетки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.АК_ЗаявкиНаПроизводствоПерсональнойУпаковки.Обороты КАК АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты
	|		ПО ЗаявкаНаПечатьЭтикеткиЭтикетки.Этикетка = АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.Номенклатура
	|			И ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка = АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.ЗаявкаНаПроизводствоПерсональнойУпаковке
	|ГДЕ
	|	ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка.СтатусЗаявки = ЗНАЧЕНИЕ(Перечисление.АК_СтатусыЗаявокНаПечатьЭтикетки.Обработано)
	|	И ЗаявкаНаПечатьЭтикеткиЭтикетки.Ссылка.Исполнитель = &Исполнитель
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.ЗаявкаНаПроизводствоПерсональнойУпаковке,
	|	АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.Номенклатура,
	|	АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.КоличествоПриход
	|ПОМЕСТИТЬ ВТ_ДвиженияДокумента
	|ИЗ
	|	РегистрНакопления.АК_ЗаявкиНаПроизводствоПерсональнойУпаковки.Обороты(, , Регистратор, ) КАК АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты
	|ГДЕ
	|	АК_ЗаявкиНаПроизводствоПерсональнойУпаковкиОбороты.Регистратор = &Регистратор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Предварительно.Заказано - ВТ_Предварительно.Пришло + ЕСТЬNULL(ВТ_ДвиженияДокумента.КоличествоПриход, 0) КАК Количество,
	|	ВТ_Предварительно.Номенклатура,
	|	ВТ_Предварительно.ЕдиницаИзмерения,
	|	ВТ_Предварительно.Ссылка КАК ЗаявкаНаПроизводствоПерсональнойУпаковки
	|ИЗ
	|	ВТ_Предварительно КАК ВТ_Предварительно
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДвиженияДокумента КАК ВТ_ДвиженияДокумента
	|		ПО ВТ_Предварительно.Номенклатура = ВТ_ДвиженияДокумента.Номенклатура
	|			И ВТ_Предварительно.Ссылка = ВТ_ДвиженияДокумента.ЗаявкаНаПроизводствоПерсональнойУпаковке
	|ГДЕ
	|	ВТ_Предварительно.Заказано + ЕСТЬNULL(ВТ_ДвиженияДокумента.КоличествоПриход, 0) - ВТ_Предварительно.Пришло > 0";
	Запрос.УстановитьПараметр("Регистратор",Ссылка);
	Запрос.УстановитьПараметр("Исполнитель",Поставщик);
	Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	Товары.Сортировать("Номенклатура Возр");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоЗаявкамПоставщикаСервер(Ссылка, Поставщик)
	
	//
	ТЗ = "ВЫБРАТЬ
	     |	Таблица.Заявка,
	     |	Таблица.Номенклатура,
	     |	Таблица.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдиницаИзмерения,
	     |	Таблица.КоличествоКПроизводствуОстаток
	     |ИЗ
	     |	РегистрНакопления.АК_ЗаявкиНаПроизводствоПерсональнойУпаковки.Остатки(&Дата, Заявка.Исполнитель = &Поставщик) КАК Таблица
	     |ГДЕ
	     |	Таблица.КоличествоКПроизводствуОстаток > 0";
	
	//
	ПЗ = Новый ПостроительЗапроса;
	ПЗ.Текст = ТЗ;
	
	//
	ПЗ.Параметры.Вставить("Дата", ?(ЗначениеЗаполнено(Ссылка), Ссылка.МоментВремени(), КонецДня(ТекущаяДата())));
	ПЗ.Параметры.Вставить("Поставщик", Поставщик);
	
	//
	ПЗ.Выполнить();
	
	//
	Выборка = ПЗ.Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		//
		Количество = МАКС(0, Выборка.КоличествоКПроизводствуОстаток); 
		Если Количество = 0 Тогда
			Продолжить;
		КонецЕсли; 
		
		//
		НоваяСтрока = Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		//
		НоваяСтрока.Количество = Количество;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьПоЗаявкамПоставщикаСервер(ВладелецФормы.Объект.Ссылка, ВладелецФормы.Объект.Поставщик);
КонецПроцедуры
