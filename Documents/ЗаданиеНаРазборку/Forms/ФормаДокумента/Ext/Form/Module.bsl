﻿
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ЕдиницаПоКлассификатору"	, СтруктураДанные.Номенклатура.БазоваяЕдиницаИзмерения);
	Запрос.УстановитьПараметр("Номенклатура"			, СтруктураДанные.Номенклатура);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Характеристика
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Владелец = &Номенклатура
	|	И НЕ ХарактеристикиНоменклатуры.Неактивная
	|	И НЕ ХарактеристикиНоменклатуры.ПометкаУдаления";
	ТабРезультат = Запрос.Выполнить().Выгрузить();
	Если ТабРезультат.Количество() = 1 Тогда
		СтруктураДанные.Характеристика = ТабРезультат[0].Характеристика;
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕдиницыИзмерения.Ссылка КАК ЕдиницаИзмерения
	|ИЗ
	|	Справочник.ЕдиницыИзмерения КАК ЕдиницыИзмерения
	|ГДЕ
	|	ЕдиницыИзмерения.Владелец = &Номенклатура
	|	И ЕдиницыИзмерения.ЕдиницаПоКлассификатору = &ЕдиницаПоКлассификатору
	|	И НЕ ЕдиницыИзмерения.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураДанные.Вставить("ЕдиницаИзмерения", Выборка.ЕдиницаИзмерения);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции

&НаСервере
Функция ПолучитьСЕ(мСклад)
	
	Возврат мСклад.Владелец;
	
КонецФункции	

//+++АК KIRN 2018.05.31 ИП-00018743.000.00000002
&НаСервере
Процедура ДоступностьРеквизитовФормы()
	Элементы.Номенклатура.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.Дата.ТолькоПросмотр = Объект.Напечатан;
	Элементы.Характеристика.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.СкладОтправитель.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.Номенклатура.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.ТоварыДатаПроизводства.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.ТоварыСтруктурнаяЕдиница.ТолькоПросмотр = Объект.Напечатан;	
	Элементы.ТоварыРасходныйОрдер.ТолькоПросмотр = Объект.Напечатан;			
	
	Элементы.ТоварыРазбитьНаНесколько.Доступность = НЕ Объект.Напечатан;
КонецПРоцедуры

	
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//+++АК sils 07.06.2018 ИП-00018876
	ОперацияАпдекс = APDEX_ОценкаПроизводительностиКлиентСервер.ПолучитьОперацию("Открытие документа Задание на разборку");
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(ОперацияАпдекс);
	//---АК

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Автор 	= ПараметрыСеанса.ТекущийПользователь;
		Объект.Дата 	= ТекущаяДата();
		Если НЕ ЗначениеЗаполнено(Объект.Склад) Тогда
			Объект.Склад = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(ПараметрыСеанса.ТекущийПользователь, "ОсновнойСклад");
		КонецЕсли;
	КонецЕсли;
	//+++АК KIRN 2018.05.31 ИП-00018743.000.00000002
	ДоступностьРеквизитовФормы();
	//---АК KIRN 
КонецПроцедуры


&НаКлиенте
Процедура СкладОтправительПриИзменении(Элемент)
	
КонецПроцедуры


&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Номенклатура"		, СтрокаТабличнойЧасти.Номенклатура);
	СтруктураДанные.Вставить("Характеристика"	, СтрокаТабличнойЧасти.Характеристика);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.Характеристика		= СтруктураДанные.Характеристика;
	СтрокаТабличнойЧасти.ЕдиницаИзмерения 	= СтруктураДанные.ЕдиницаИзмерения;
	СтрокаТабличнойЧасти.Количество 		= 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьЛогиМП(Команда)
	Структура1=Новый Структура("Документ",ЭтаФорма.Объект.Ссылка);
	ПараметрыВыбора=Новый Структура("Отбор",Структура1);
	ОткрытьФорму("РегистрСведений.МП_ЖурналОбмена.Форма.ФормаСписка",ПараметрыВыбора,ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	КолвоВКоробке=ПолучитьКолВКоробке();
	СтрокаТаб=Элементы.Товары.ТекущиеДанные;
	СтрокаТаб.КоличествоКоробок = ?(КолвоВКоробке = 0, 0, Цел(СтрокаТаб.Количество / КолвоВКоробке));
КонецПроцедуры

&НаСервере
Функция ПолучитьКолВКоробке()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ХарактеристикиНоменклатуры.Ссылка КАК Ссылка,
	//+++АК KIRN 2018.07.10 ИП-00019243 
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ХарактеристикиНоменклатуры.БратьКоличествоВКоробкеПоСкладуДляРаспределения, ЛОЖЬ)
	|			ТОГДА ЕСТЬNULL(КоличествоВКоробкеСрезПоследних.Количество, 0)
	|		ИНАЧЕ ЕСТЬNULL(ЗначенияСвойствОбъектов.Значение, 0)
	|	КОНЕЦ КАК КоличествоВУпаковке
	//---АК KIRN 
	|ИЗ
	|	Справочник.ХарактеристикиНоменклатуры КАК ХарактеристикиНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектов
	|		ПО ХарактеристикиНоменклатуры.Ссылка = ЗначенияСвойствОбъектов.Объект
	|			И (ЗначенияСвойствОбъектов.Свойство = ЗНАЧЕНИЕ(ПланВидовХарактеристик.СвойстваОбъектов.КоличествоВУпаковке))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КоличествоВКоробке.СрезПоследних(
	|				,
	|				Номенклатура = &Номенклатура
	|					И Характеристика = &Ссылка) КАК КоличествоВКоробкеСрезПоследних
	|		ПО ХарактеристикиНоменклатуры.Ссылка = КоличествоВКоробкеСрезПоследних.Характеристика
	|ГДЕ
	|	ХарактеристикиНоменклатуры.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Характеристика);
	Запрос.УстановитьПараметр("Номенклатура", Объект.Номенклатура);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.КоличествоВУпаковке;
	КонецЦикла;
	
	Возврат 0;	
КонецФункции // ()


&НаКлиенте
Процедура ТоварыКоличествоКоробокПриИзменении(Элемент)
	КолвоВКоробке=ПолучитьКолВКоробке();
	СтрокаТаб=Элементы.Товары.ТекущиеДанные;
	СтрокаТаб.Количество = ?(КолвоВКоробке = 0, 0, (СтрокаТаб.КоличествоКоробок * КолвоВКоробке));
КонецПроцедуры


&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	Объект.Товары.Очистить();
КонецПроцедуры


&НаКлиенте
Процедура НапечатанПриИзменении(Элемент)
	ДоступностьРеквизитовФормы();
КонецПроцедуры

//+++АК KIRN 2018.05.31 ИП-00018743.000.00000002 
&НаКлиенте
Процедура ТоварыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если объект.Напечатан Тогда
		Сообщить("Запрещено редактирование документа с признаком ""Напечатан""");
		Отказ = ИСтина;
	КонецЕСли;
КонецПроцедуры

//+++АК KIRN 2018.05.31 ИП-00018743.000.00000002 
&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	Если объект.Напечатан Тогда
		Сообщить("Запрещено редактирование документа с признаком ""Напечатан""");
		Отказ = ИСтина;
	КонецЕСли;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени(ОперацияАпдекс, ?(Параметры.Ключ.Пустая(), "Новый документ", "" + Объект.Ссылка));	
КонецПроцедуры


//+++АК KIRN 2018.07.03  
&НаКлиенте
Процедура УдалитьЗаданиеИзРО(Команда)
	УдалитьЗаданиеИзРОНаСервере();
КонецПроцедуры

//+++АК KIRN 2018.07.03  
&НаСервере
Процедура УдалитьЗаданиеИзРОНаСервере()
	Документы.ЗаданиеНаРазборку.УдалитьЗаданиеИзРО(Объект.Ссылка);
КонецПроцедуры

//+++АК KIRN 2018.07.27 ИП-00019352 
Функция СоздатьДробныйДокумент(н1,н2,мсСтрокиКУдалению)
	ЗаданиеНаРазборку = Документы.ЗаданиеНаРазборку.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(ЗаданиеНаРазборку,Объект,,"Номер");
	ЗаданиеНаРазборку.Автор = ПараметрыСеанса.ТекущийПользователь;
	ЗаданиеНаРазборку.Комментарий = "#часть документа "+Объект.Номер+" (строки "+н1+" - "+н2+")";
	Для нн = н1 по н2 Цикл
		НС = ЗаданиеНаРазборку.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НС, Объект.Товары[нн]);
		НС.РасходныйОрдер = Документы.РасходныйОрдерСклад.ПустаяСсылка();
		мсСтрокиКУдалению.Добавить(Объект.Товары[нн]);
	КонецЦикла;
	Если ЗаданиеНаРазборку.Товары.Количество()>0 Тогда
		ЗаданиеНаРазборку.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	Возврат ЗаданиеНаРазборку.Ссылка;
КонецФункции


//+++АК KIRN 2018.07.27 ИП-00019352 
&НаСервере
Процедура РазбитьНаНесколькоНаСервере(пК)
	мсНовыеЗадания = Новый Массив;
	мсСтрокиКУдалению = Новый Массив;
	ВсегоСтрок = Объект.Товары.Количество();
	д = Окр(ВсегоСтрок/пК,0,РежимОкругления.Окр15как10);
	Отказ = Ложь;
	НачатьТранзакцию();
	Для н = 1 по пК-2 Цикл
		ДокСсылка = СоздатьДробныйДокумент(н*д,(н+1)*д-1,мсСтрокиКУдалению);
		мсНовыеЗадания.Добавить(ДокСсылка);
	КонецЦикла;
	ДокСсылка = СоздатьДробныйДокумент((пК-1)*д,ВсегоСтрок-1,мсСтрокиКУдалению);
	мсНовыеЗадания.Добавить(ДокСсылка);
	
	Для Каждого стр из мсСтрокиКУдалению Цикл
		Если ЗначениеЗаполнено(стр.РасходныйОрдер) ТОгда
			РО = стр.РасходныйОрдер.ПолучитьОбъект();
			СтрокиТЧ = РО.Товары.НайтиСтроки(Новый Структура("Номенклатура, Характеристика, ДатаПроизводства, ЗаданиеНаРазборку",Объект.Номенклатура, Объект.Характеристика, Стр.ДатаПроизводстваПред, Объект.Ссылка));
			Если СтрокиТЧ.Количество()>0 Тогда
				РО.Товары.Удалить(СтрокиТЧ[0]);
				РО.Записать();
			КонецЕСли;
		КонецЕСли;
		Объект.Товары.Удалить(стр);
	КонецЦикла;
	Записать();
		
	ЗафиксироватьТранзакцию();
	
	//Обработки.ЗаполнитьРасходникиПоЗаданиямНаРазборку.ЗаполнитьРасходникиНовымиЗаданиями(Объект.Дата,мсНовыеЗадания,Объект.Склад);
	Обработки.ЗаполнитьРасходникиПоЗаданиямНаРазборку.ЗаполнитьРасходники(Новый Структура("ДатаРаспределения, СписокЗаданий, Склад", Объект.Дата,мсНовыеЗадания,Объект.Склад));
КонецПроцедуры

//+++АК KIRN 2018.07.27 ИП-00019352 
&НаКлиенте
Процедура РазбитьНаНесколько(Команда)
	Оп = Новый ОписаниеОповещения("РазбитьНаНесколькоЗакрытиеФормыВводаПараметров",ЭтаФорма);
	ФормаПараметров = ОткрытьФорму("Документ.ЗаданиеНаРазборку.Форма.ФормаВводаПараметровУпр",Новый Структура("ВсегоСтрок",Объект.Товары.Количество()),ЭтаФорма, Новый УникальныйИдентификатор,,,Оп);
	ФормаПараметров.Открыть();
КонецПроцедуры

//+++АК KIRN 2018.07.27  ИП-00019352
Процедура РазбитьНаНесколькоЗакрытиеФормыВводаПараметров(Результат = Неопределено, Параметры = Неопределено)
	Если ТипЗнч(Результат)=Тип("Структура") Тогда	
		Если Результат.Свойство("КоличествоЧастей") ТОгда
			Если Результат.КоличествоЧастей>1 Тогда
				РазбитьНаНесколькоНаСервере(Результат.КоличествоЧастей);
			КонецЕСли;
		КонецЕСли;
	КонецЕСли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ДоступностьРеквизитовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Напечатали" И Параметр.Найти(Объект.Ссылка)<> Неопределено Тогда		
		Прочитать();
		ДоступностьРеквизитовФормы();
	ИначеЕсли ИмяСобытия = "ДобавилиЗаданияВРО" и Параметр.Найти(Объект.Ссылка)<> Неопределено Тогда
		Прочитать();
		ДоступностьРеквизитовФормы();
	ИначеЕсли ИмяСобытия = "УдалилиЗаданияВРО" и Параметр.Найти(Объект.Ссылка)<> Неопределено Тогда
		Прочитать();
		ДоступностьРеквизитовФормы()
	КонецЕсли;
КонецПроцедуры

//++АК hamz 2018.12.05 ИП-00020652      
&НаКлиенте
Процедура ПодготовленПриИзменении(Элемент)
	Галка = Объект.Подготовлен;
	Если Галка Тогда
		МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("Собран", Не Галка));
		Если МассивСтрок.Количество() >0 Тогда 
			Оповещение = Новый ОписаниеОповещения("ПриИзмененииПодготовлен", ЭтаФорма, Новый Структура("МассивСтрок, Галка", МассивСтрок, Галка));
			ПоказатьВопрос(Оповещение,"Поставить признак ""Собран"" в строках табличной части?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
		КонецЕсли;
	Иначе
		МассивСтрок = Объект.Товары.НайтиСтроки(Новый Структура("Собран", Не Галка));
		Если МассивСтрок.Количество() >0 Тогда 
			Оповещение = Новый ОписаниеОповещения("ПриИзмененииПодготовлен", ЭтаФорма, Новый Структура("МассивСтрок, Галка", МассивСтрок, Галка));
			ПоказатьВопрос(Оповещение,"Снять признак ""Собран"" в строках табличной части?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПодготовлен(Результат, ДопПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Галка = ДопПараметры.Галка;
		Для каждого Стр Из ДопПараметры.МассивСтрок Цикл
			Стр.Собран = Галка;
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры 
//--АК hamz