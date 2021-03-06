﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//Представление = "(" + ОбщегоНазначенияКлиентСервер.ФорматПоля(Данные.Ссылка.code_operation) + ") " + Данные.Ссылка.name_operation;
	
КонецПроцедуры

Процедура ЗагрузитьИзSQL() Экспорт
	
	ADOСоединение = ВнешниеДанные.ПолучитьADOСоединение();	

	ТекстЗапросаSQL =  "
  |  SELECT 
  |    table_operation,
  |    field_operation,
  |    code_operation,
  |    name_operation,
  |    type_operation,
  |    for_user_vv,
  |    is_photo,
  |	   znak
  |FROM SMS_Repl.dbo.Types_Operation";
  
	rs = ADOСоединение.Execute(ТекстЗапросаSQL);
	rs.MoveFirst();
	Результат = ВнешниеДанные.ПреобразоватьРезультатВТаблицуЗначений(rs);
	
	ЗапросТипыОпераций = Новый Запрос;
	ЗапросТипыОпераций.Текст = "ВЫБРАТЬ
	                           |	ТипыОпераций.Ссылка,
	                           |	ТипыОпераций.code_operation,
	                           |	ТипыОпераций.table_operation,
	                           |	ТипыОпераций.field_operation,
							   |	ЛОЖЬ КАК Обработан
	                           |ИЗ
	                           |	Справочник.ТипыОперацийМагазина КАК ТипыОпераций";
							   
	ТзТипыОпераций = ЗапросТипыОпераций.Выполнить().Выгрузить();
	
	Для Каждого Выборка ИЗ Результат Цикл
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("code_operation", Выборка.code_operation);
		СтруктураПоиска.Вставить("table_operation", Выборка.table_operation);
		Структурапоиска.Вставить("field_operation", Выборка.field_operation);
		
		НайдСтр = ТзТипыОпераций.НайтиСтроки(СтруктураПоиска);
		
		Если НайдСтр.Количество() = 0 Тогда
			ЭлТипыОпераций = Справочники.ТипыОперацийМагазина.СоздатьЭлемент();
		Иначе
			ЭлТипыОпераций = НайдСтр[0].Ссылка.ПолучитьОбъект();
			НайдСтр[0].Обработан = Истина;
		КонецЕсли;		
		
		Если ЭлТипыОпераций.ЭтоНовый() Тогда
			ЭлТипыОпераций.table_operation = Выборка.table_operation;
			ЭлТипыОпераций.field_operation = Выборка.field_operation;
			ЭлТипыОпераций.code_operation = Выборка.code_operation;
			ЭлТипыОпераций.name_operation = Выборка.name_operation;
			ЭлТипыОпераций.Наименование = "(" + Выборка.code_operation + ")" + Выборка.name_operation;
			ЭлТипыОпераций.type_operation = Выборка.type_operation;
			ЭлТипыОпераций.for_user_vv = Выборка.for_user_vv;
			ЭлТипыОпераций.is_photo = Выборка.is_photo;
			ЭлТипыОпераций.znak = Выборка.znak;
				
			Модифицирован = Истина;
		Иначе
			Модифицирован = Ложь;
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"table_operation", Выборка.table_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"field_operation", Выборка.field_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"code_operation"	,Выборка.code_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"name_operation"	,Выборка.name_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"Наименование"	,"(" + Выборка.code_operation + ")" + Выборка.name_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"type_operation"	,Выборка.type_operation	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"for_user_vv"	,Выборка.for_user_vv	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"is_photo"	,Выборка.is_photo	,Модифицирован);
			ОбменСAccess.ПроверкаМодифицированности(ЭлТипыОпераций,"znak"			,Выборка.znak	,Модифицирован);
		КонецЕсли;                                              
		
		Если Модифицирован Тогда
			ЭлТипыОпераций.Записать();
		КонецЕсли

	КонецЦикла;
	
	ADOСоединение.Close();
	
	Для Каждого Стр Из ТзТипыОпераций Цикл
		Если НЕ Стр.Обработан Тогда
			ОперацияОб = Стр.Ссылка.ПолучитьОбъект();
			ОперацияОб.УстановитьПометкуУдаления(Истина);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
	
