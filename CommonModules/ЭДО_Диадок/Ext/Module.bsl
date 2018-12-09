﻿/////////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

Функция ПолучитьНастройкиОрганизации(ДиадокСоединение, Organization)
	
	НастройкиОрганизации = Новый Структура;
	
	НастройкиОрганизации.Вставить("Connection", ДиадокСоединение);
	НастройкиОрганизации.Вставить("Organization", Organization);
	
	ДанныеСотрудника = Новый Структура;
	
	ConnectionUser = ДиадокСоединение.GetMyUser();
	
	ДанныеСотрудника.Вставить("Фамилия" , ConnectionUser.LastName);
	ДанныеСотрудника.Вставить("Имя"	 , ConnectionUser.FirstName);
	ДанныеСотрудника.Вставить("Отчество", ConnectionUser.MiddleName);
	
	ФИО = "";
	Разделитель = "";
	Если ЗначениеЗаполнено(ДанныеСотрудника.Фамилия) Тогда
		ФИО = ФИО + Разделитель + ДанныеСотрудника.Фамилия;
		Разделитель = " ";
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеСотрудника.Имя) Тогда
		ФИО = ФИО + Разделитель + ДанныеСотрудника.Имя;
		Разделитель = " ";
	КонецЕсли;
	Если ЗначениеЗаполнено(ДанныеСотрудника.Отчество) Тогда
		ФИО = ФИО + Разделитель + ДанныеСотрудника.Отчество;
		Разделитель = " ";
	КонецЕсли;
	
	ДанныеСотрудника.Вставить("ФИО", ФИО);
	
	Попытка
		НастройкиОрганизации.Organization.GetUserPermissions();
		НастройкиОрганизации.Вставить("ЗаблокированаПоAPI", Ложь);				
	Исключение
		НастройкиОрганизации.Вставить("ЗаблокированаПоAPI", Истина);				
	КонецПопытки;
	
	Если НЕ НастройкиОрганизации.ЗаблокированаПоAPI Тогда
		UserPermissions = Organization.GetUserPermissions();
		
		ДанныеСотрудника.Вставить("Должность", UserPermissions.JobTitle);
		
		ДанныеСотрудника.Вставить("ПраваДоступа", Новый Структура);
		ДанныеСотрудника.ПраваДоступа.Вставить("IsAdministrator"	   , UserPermissions.IsAdministrator);
		ДанныеСотрудника.ПраваДоступа.Вставить("CanSignDocuments"	   , UserPermissions.CanSignDocuments);
		ДанныеСотрудника.ПраваДоступа.Вставить("CanAddResolutions"	   , UserPermissions.CanAddResolutions);
		ДанныеСотрудника.ПраваДоступа.Вставить("CanRequestResolutions", UserPermissions.CanRequestResolutions);
		ДанныеСотрудника.ПраваДоступа.Вставить("DocumentsAccessLevel" , UserPermissions.DocumentsAccessLevel);
	КонецЕсли;
	
	НастройкиОрганизации.Вставить("ДанныеСотрудника", ДанныеСотрудника);
	
	Возврат НастройкиОрганизации;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////
// ПОДКЛЮЧЕНИЕ И АВТОРИЗАЦИЯ

Функция ПолучитьСоединение(Организация, Пользователь = Неопределено) Экспорт
	
		ДиадокAPI = Неопределено;
		
		Попытка 
			ДиадокAPI = Новый COMОбъект("Diadoc.DiadocClient");	
		Исключение
			УстановитьКомпоненту();
		КонецПопытки; 
		
		Если ДиадокAPI = Неопределено Тогда
			Попытка 
				ДиадокAPI = Новый COMОбъект("Diadoc.DiadocClient");	
			Исключение
				ЭДО_ОбщегоНазначения.СообщитьОбОшибке("Диадок. Не удалось получить COM-объект.");
				Возврат Неопределено;
			КонецПопытки; 
		КонецЕсли; 
		
		// Авторизация
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	ЭДО_КаналыОбмена.АдресПодключения,
		                      |	ЭДО_КаналыОбмена.ИдентификаторКлиентаAPI
		                      |ИЗ
		                      |	Справочник.ЭДО_КаналыОбмена КАК ЭДО_КаналыОбмена
		                      |ГДЕ
		                      |	ЭДО_КаналыОбмена.Ссылка = ЗНАЧЕНИЕ(Справочник.ЭДО_КаналыОбмена.Диадок)");
		
		НастройкиДиадок = Запрос.Выполнить().Выбрать();
		
		НастройкиДиадок.Следующий();
		
		ДиадокAPI.ApiClientId = НастройкиДиадок.ИдентификаторКлиентаAPI;
		ДиадокAPI.ServerUrl   = НастройкиДиадок.АдресПодключения;
		
		ПараметрыАвторизации = ЭДО_ОбщегоНазначения.ПолучитьПараметрыАвторизации(Справочники.ЭДО_КаналыОбмена.Диадок, Организация, Пользователь);
		
		Если ПараметрыАвторизации = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли; 
		
		Попытка 
			Если ПараметрыАвторизации.АвторизацияПоСертификату Тогда
				ДиадокСоединение = ДиадокAPI.CreateConnectionByCertificate(ПараметрыАвторизации.ОтпечатокСертификата);				
			Иначе
				Логин = ПараметрыАвторизации.Логин;
				Пароль = ПараметрыАвторизации.Пароль.Получить();
			
				ДиадокСоединение = ДиадокAPI.CreateConnectionByLogin(Логин, Пароль);
			КонецЕсли; 
			
		Исключение
			ЭДО_ОбщегоНазначения.СообщитьОбОшибке("Диадок. Не удалось произвести авторизацию. " + ОписаниеОшибки());
			Возврат Неопределено;
			
		КонецПопытки; 
		
		Возврат ДиадокСоединение;
	
КонецФункции

Процедура УстановитьКомпоненту()
		
	КаталогВременныхФайлов = КаталогВременныхФайлов();
	
	Если Прав(КаталогВременныхФайлов, 1) <> "\" Тогда
		КаталогВременныхФайлов = КаталогВременныхФайлов + "\";
	КонецЕсли;

	//Загрузка внешней компоненты
	ФайлКомпоненты = Новый Файл(КаталогВременныхФайлов + "\DiadocComAPI.dll");
	
	Если НЕ ФайлКомпоненты.Существует() Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация;
		
		Если Найти(Строка(СистемнаяИнформация.ТипПлатформы), "64") > 0 Тогда
			СтрокаТипПлатформы = "_x86_64";
		Иначе
			СтрокаТипПлатформы = "_x86";
		КонецЕсли;
		
		Справочники.ЭДО_КаналыОбмена.ПолучитьМакет("Diadoc_COM_API" + СтрокаТипПлатформы).Записать(ФайлКомпоненты.ПолноеИмя);	
	КонецЕсли;

	// Утилита RegSvr32 гарантировано устанавливает компоненту в профиль пользователя,
	// без необходимости повышения прав до административных используя только DLLInstall.
	ЗапуститьПриложение("RegSvr32 """+ ФайлКомпоненты.ПолноеИмя +""" /s /n /i:user", , Истина);
			
КонецПроцедуры

Функция ПолучитьКэш(Пользователь = Неопределено) Экспорт
	
	КэшДиадок = Новый Структура;
	
	КэшДиадок.Вставить("Организации",  Новый Соответствие);
	
	НастройкиОбменаПоОрганизациям = ЭДО_ОбщегоНазначения.ПолучитьНастройкиОбменаПоОрганизациям(Справочники.ЭДО_КаналыОбмена.Диадок);	
	
	Для Каждого СтрокаНастроек Из НастройкиОбменаПоОрганизациям Цикл
		Организация = СтрокаНастроек.Организация;
		
		ДиадокСоединение = ПолучитьСоединение(Организация, Пользователь);
		
		Если ДиадокСоединение = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
		
		// Ищем нужную организацию в учетной записи
		OrganizationList = ДиадокСоединение.GetOrganizationList();
	
		
		Organization = Неопределено;
	  	Сч = 0;	
			                                                     
		Пока Сч < OrganizationList.Count() Цикл
			Organization = OrganizationList.GetItem(Сч);
			
			Если Organization.INN = Организация.ИНН Тогда
				Прервать;
			КонецЕсли; 
			
			Organization = Неопределено;			
			Сч = Сч + 1;
		КонецЦикла;
		
		Если Organization = Неопределено Тогда
			Продолжить;
		КонецЕсли; 
				
		НастройкиОрганизации = ПолучитьНастройкиОрганизации(ДиадокСоединение, Organization);		
		
		НастройкиОрганизации.Вставить("ДатаНачалаЗагрузки", СтрокаНастроек.ДатаНачалаЗагрузки);
		НастройкиОрганизации.Вставить("ИдентификаторПоследнегоСобытия", СтрокаНастроек.ИдентификаторПоследнегоСобытия);
		НастройкиОрганизации.Вставить("ДатаПоследнегоСобытия", СтрокаНастроек.ДатаПоследнегоСобытия);
		
		КэшДиадок.Организации.Вставить(Организация, НастройкиОрганизации);
	КонецЦикла;  
	
	КэшДиадок.Вставить("КаталогЗагрузкиФайлов", ЭДО_ОбщегоНазначения.ПолучитьКаталогЗагрузкиФайлов());
	
	Возврат КэшДиадок;
	
КонецФункции


/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЗАГРУЗКИ ДОКУМЕНТОВ

Процедура ПолучитьДокументОснованиеИзКонтурEDI(ДокументОбъект)
	НомерДляПоиска =  "";
	Если ЗначениеЗаполнено(ДокументОбъект.ФайлXML) = Истина Тогда
		СтруктураДокумента = Новый Структура("ЭДО_ВходящийДокумент, Контрагент, СписокДокументов, ДанныеШапки, Подписан, ТабличнаяЧасть, ПутьКФайлуPDF");			
		Обработки.ЭДО_Интерфейс.ПрочитатьСтруктуруXML(ДокументОбъект.ФайлXML, СтруктураДокумента, Ложь);	
		
		Если ЗначениеЗаполнено(СтруктураДокумента.ДанныеШапки.Номер) = Истина Тогда
			НомерДляПоиска = СтруктураДокумента.ДанныеШапки.Номер; 
		КонецЕсли;	
	Иначе
		НомерДляПоиска = ДокументОбъект.Номер;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	КонтурEDI_Сообщения.Документ КАК Документ,
	|	ВЫБОР
	|		КОГДА КонтурEDI_Сообщения.ТипСообщения = ""INVOIC""
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Приоритет
	|ИЗ
	|	Справочник.КонтурEDI_Сообщения КАК КонтурEDI_Сообщения
	|ГДЕ
	|	КонтурEDI_Сообщения.НомерДокумента = &НомерДокумента
	|	И КонтурEDI_Сообщения.ТипСообщения В (""INVOIC"", ""DESADV"")
	|	И КонтурEDI_Сообщения.Документ.Ссылка ЕСТЬ НЕ NULL 
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет УБЫВ";
	
	Запрос.УстановитьПараметр("НомерДокумента", СокрЛП(НомерДляПоиска));
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	
	Документ = Неопределено;
	
	Если ТЗ.Количество() > 0 Тогда
		Документ = ТЗ[0].Документ;		
		ДокументОбъект.ДокументОснование = Документ; 
	КонецЕсли;	
	
КонецПроцедуры

Функция ПолучитьНаправлениеОбмена(Direction)
	
	Если  ВРег(СокрЛП(Direction)) = "INBOUND" Тогда
		Возврат Перечисления.ЭДО_НаправленияДокументов.Входящий;
	ИначеЕсли  ВРег(СокрЛП(Direction)) = "OUTBOUND" Тогда
		Возврат Перечисления.ЭДО_НаправленияДокументов.Исходящий;
	КонецЕсли; 

КонецФункции 

Функция ПолучитьДанныеКонтрагента(Counteragent)
	
	ДанныеКонтрагента = Новый Структура("Адрес");
	
	ДанныеКонтрагента.Вставить("ИНН", Counteragent.Inn);
	ДанныеКонтрагента.Вставить("КПП", Counteragent.Kpp);	
	ДанныеКонтрагента.Вставить("Наименование", Counteragent.Name);	
	
	// Адрес есть не всегда
	Попытка 
		ДанныеКонтрагента.Вставить("Адрес", Counteragent.Address);	
	Исключение
	КонецПопытки; 
	
	
	Возврат ДанныеКонтрагента;
	
КонецФункции 

Функция ПолучитьСуммуПакета(ИдентификаторПакета) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЕСТЬNULL(МАКСИМУМ(ЭДО_ВходящийДокумент.СуммаДокумента), 0) КАК СуммаПакета
	                      |ИЗ
	                      |	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	                      |ГДЕ
	                      |	ЭДО_ВходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета");
				   
   Запрос.УстановитьПараметр("ИдентификаторПакета", ИдентификаторПакета);
   
   Выборка = Запрос.Выполнить().Выбрать();
   
   Выборка.Следующий(); 
   
   Возврат Выборка.СуммаПакета;
   
КонецФункции

Функция ПолучитьСтатусПакета(ИдентификаторПакета) Экспорт
	
	// В Диадоке у документов в пакете могут быть разные статусы	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭДО_ВходящийДокумент.Статус.Статус КАК Статус
	|ИЗ
	|	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	|ГДЕ
	|	ЭДО_ВходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭДО_ИсходящийДокумент.Статус.Статус
	|ИЗ
	|	Документ.ЭДО_ИсходящийДокумент КАК ЭДО_ИсходящийДокумент
	|ГДЕ
	|	ЭДО_ИсходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета");
				   
   Запрос.УстановитьПараметр("ИдентификаторПакета", ИдентификаторПакета);
   
   Выборка = Запрос.Выполнить().Выбрать();
   
   Если Выборка.Количество() = 1 Тогда
	   Выборка.Следующий(); 
   
	   Возврат Выборка.Статус;
   КонецЕсли; 
   
   Возврат Перечисления.ЭДО_СтатусыДокументов.Прочее;
   
КонецФункции

Функция ПолучитьСтатусПакетаОператор(ИдентификаторПакета) Экспорт
	
	// В Диадоке у документов в пакете могут быть разные статусы	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭДО_ВходящийДокумент.Статус КАК Статус
	|ИЗ
	|	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	|ГДЕ
	|	ЭДО_ВходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЭДО_ИсходящийДокумент.Статус
	|ИЗ
	|	Документ.ЭДО_ИсходящийДокумент КАК ЭДО_ИсходящийДокумент
	|ГДЕ
	|	ЭДО_ИсходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета");
				   
   Запрос.УстановитьПараметр("ИдентификаторПакета", ИдентификаторПакета);
   
   Выборка = Запрос.Выполнить().Выбрать();
   
   Если Выборка.Количество() = 1 Тогда
	   Выборка.Следующий(); 
   
	   Возврат Выборка.Статус;
   КонецЕсли; 
   
   Возврат Неопределено;
   
КонецФункции

Функция ПолучитьПредставлениеДокумента(ПараметрыДокумента) Экспорт
	
	Представление = Строка(ПараметрыДокумента.ТипДокумента.ТипДокумента);
	
	Если ЗначениеЗаполнено(ПараметрыДокумента.Номер) Тогда
		Представление = Представление + " № " + ПараметрыДокумента.Номер;
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПараметрыДокумента.Дата) Тогда
		Представление = Представление + " от " + Формат(ПараметрыДокумента.Дата, "ДФ=dd.MM.yyyy");
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ПараметрыДокумента.СуммаДокумента) Тогда
		Представление = Представление + " на сумму " + Формат(ПараметрыДокумента.СуммаДокумента, "ЧДЦ=2; ЧН=") + " р.";
		Представление = Представление + " НДС " + Формат(ПараметрыДокумента.СуммаНДС, "ЧДЦ=2; ЧН=") + " р.";
	КонецЕсли; 
	
	Возврат Представление;
	
КонецФункции 

Функция ЭтоПолучениеДокумента(DocumentEvent) Экспорт
	
	Возврат DocumentEvent.EventType = "New";
	
КонецФункции 

Функция ДокументБылЗагружен(DocumentEvent) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЭДО_ВходящийДокумент.Ссылка
	|ИЗ
	|	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	|ГДЕ
	|	ЭДО_ВходящийДокумент.ИдентификаторДокумента = &ИдентификаторДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЭДО_ИсходящийДокумент.Ссылка
	|ИЗ
	|	Документ.ЭДО_ИсходящийДокумент КАК ЭДО_ИсходящийДокумент
	|ГДЕ
	|	ЭДО_ИсходящийДокумент.ИдентификаторДокумента = &ИдентификаторДокумента");
	
	Запрос.УстановитьПараметр("ИдентификаторДокумента", DocumentEvent.DocumentId);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
	
КонецФункции 

Функция ПолучитьСписокСобытий(Кэш, Организация) Экспорт
	
	НастройкиОрганизации = Кэш.Организации[Организация];
	
	DocumentEventList = НастройкиОрганизации.Organization.GetDocumentEventList(НастройкиОрганизации.ИдентификаторПоследнегоСобытия);
	
	СписокСобытий = Новый Массив;

  	Сч = 0;	

	Пока Сч < DocumentEventList.Count() Цикл
		DocumentEvent = DocumentEventList.GetItem(Сч);
		Сч = Сч + 1;
		
		СтруктураСобытия = Новый Структура();
		
		СтруктураСобытия.Вставить("Событие",  DocumentEvent);
		СтруктураСобытия.Вставить("ИдентификаторСобытия",  DocumentEvent.EventId);
		СтруктураСобытия.Вставить("ДатаСобытия",  DocumentEvent.Timestamp);
		
		СписокСобытий.Добавить(СтруктураСобытия);
	КонецЦикла;

	Возврат СписокСобытий;
	
КонецФункции 


Процедура ЗагрузитьДокумент(Document, Организация, DocumentEvent = Неопределено, КаталогЗагрузкиФайлов = Неопределено, ОбновитьФайлы = Ложь, ДокументОснование = Неопределено) Экспорт
	
	Если КаталогЗагрузкиФайлов = Неопределено Тогда
		КаталогЗагрузкиФайлов = ЭДО_ОбщегоНазначения.ПолучитьКаталогЗагрузкиФайлов();		
	КонецЕсли; 
	
	// Загружаем только входящие
	НаправлениеОбмена = ПолучитьНаправлениеОбмена(Document.Direction);
	
	Если НаправлениеОбмена = Перечисления.ЭДО_НаправленияДокументов.Входящий Тогда
		ДокументСсылка = Документы.ЭДО_ВходящийДокумент.НайтиПоРеквизиту("ИдентификаторДокумента", Document.DocumentId);
	Иначе	
		ДокументСсылка = Документы.ЭДО_ИсходящийДокумент.НайтиПоРеквизиту("ИдентификаторДокумента", Document.DocumentId);		
	КонецЕсли; 
	
	
	// Создаем/обновляем данные по документу
	МЗ_Пакет = РегистрыСведений.ЭДО_Пакеты.СоздатьМенеджерЗаписи();
	
	ИдентификаторПакета = Document.DocumentId;	
	
	Если НЕ ПустаяСтрока(Document.PackageId) Тогда
		ИдентификаторПакета = Document.PackageId;
	КонецЕсли; 
	
	МЗ_Пакет.ИдентификаторПакета = ИдентификаторПакета;
	МЗ_Пакет.Прочитать();
	
	//
	
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
	    ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	Иначе
		Если НаправлениеОбмена = Перечисления.ЭДО_НаправленияДокументов.Входящий Тогда
			ДокументОбъект = Документы.ЭДО_ВходящийДокумент.СоздатьДокумент();	
		Иначе	
			ДокументОбъект = Документы.ЭДО_ИсходящийДокумент.СоздатьДокумент();	
		КонецЕсли; 		
		
		ДокументОбъект.ИдентификаторДокумента = Document.DocumentId;

		Если ЗначениеЗаполнено(Document.DocumentDate) И Document.DocumentDate > Дата(2000,1,1)  Тогда
			ДокументОбъект.Дата = Document.DocumentDate;
		Иначе
			ДокументОбъект.Дата = Document.Timestamp;
		КонецЕсли; 
		
		ДокументОбъект.Номер = Document.DocumentNumber;
	КонецЕсли; 
	
	ДокументОбъект.ИдентификаторПакета = ИдентификаторПакета;
	ДокументОбъект.КаналОбмена = Справочники.ЭДО_КаналыОбмена.Диадок;
	ДокументОбъект.Организация = Организация;
	
	ДанныеКонтрагента = ПолучитьДанныеКонтрагента(Document.Counteragent);
	ДокументОбъект.КонтрагентЭДО = ЭДО_ОбщегоНазначения.НайтиСоздатьКонтрагента(Справочники.ЭДО_КаналыОбмена.Диадок, ДанныеКонтрагента);	
	
	ДокументОбъект.Статус = ЭДО_ОбщегоНазначения.НайтиСоздатьСтатусДокумента(Справочники.ЭДО_КаналыОбмена.Диадок, Document.Status, Document.Status);
	ДокументОбъект.ТипДокумента = ЭДО_ОбщегоНазначения.НайтиСоздатьТипДокумента(Справочники.ЭДО_КаналыОбмена.Диадок, Document.Type);
	ДокументОбъект.ДатаЗагрузки = ТекущаяДата();
	
	Попытка 
		ДокументОбъект.СуммаДокумента = Document.Total;
	Исключение
		ДокументОбъект.СуммаДокумента = 0;
	КонецПопытки; 

	Попытка 
		ДокументОбъект.СуммаНДС = Document.Vat;
	Исключение
		ДокументОбъект.СуммаНДС = 0;
	КонецПопытки;  
	
	ДокументОбъект.ПредставлениеДокумента = ПолучитьПредставлениеДокумента(ДокументОбъект);
	
	// Загружаем файлы
	Попытка 
		Document.SaveAllContent(КаталогЗагрузкиФайлов);
	Исключение	
		
	КонецПопытки;	
	
	ИмяФайлаДокумента = Document.FileName;
	
	Если ОбновитьФайлы = Ложь И ЗначениеЗаполнено(ДокументСсылка) И ДокументОбъект.Статус <> ДокументОбъект.Ссылка.Статус Тогда
		 ОбновитьФайлы = Истина;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.ФайлXML) ИЛИ ОбновитьФайлы Тогда 
		ДокументОбъект.ФайлXML = ЭДО_ОбщегоНазначения.СоздатьОбновитьФайлДокумента(КаталогЗагрузкиФайлов, ИмяФайлаДокумента , "xml", ДокументОбъект.ФайлXML, ДокументОбъект.ИдентификаторДокумента, ДокументОбъект.Дата);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокументОбъект.ФайлPDF) ИЛИ ОбновитьФайлы Тогда 
		ДокументОбъект.ФайлPDF = ЭДО_ОбщегоНазначения.СоздатьОбновитьФайлДокумента(КаталогЗагрузкиФайлов, ИмяФайлаДокумента , "pdf", ДокументОбъект.ФайлPDF, ДокументОбъект.ИдентификаторДокумента, ДокументОбъект.Дата);
	КонецЕсли;
	
	//+++ AK suvv 2018.12.06 ИП-00020608 
	Если Document.type = "NonformalizedAcceptanceCertificate" и не ЗначениеЗаполнено(ДокументОбъект.ФайлPDF) Тогда
		НайденныеФайлы = НайтиФайлы(КаталогЗагрузкиФайлов, "*.pdf", Ложь);
		Если НайденныеФайлы.Количество() > 0 Тогда
			ИмяФайлаДляЗагрузки = НайденныеФайлы[0].Имя;
			ДокументОбъект.ФайлPDF = ЭДО_ОбщегоНазначения.СоздатьОбновитьФайлДокумента(КаталогЗагрузкиФайлов, ИмяФайлаДляЗагрузки , "pdf", ДокументОбъект.ФайлPDF, ДокументОбъект.ИдентификаторДокумента, ДокументОбъект.Дата);
		КонецЕсли;
	КонецЕсли;
	//--- AK suvv
	
	Если НЕ ПустаяСтрока(КаталогЗагрузкиФайлов) Тогда
		УдалитьФайлы(КаталогЗагрузкиФайлов, "*.*");
	КонецЕсли;
	
	Если НаправлениеОбмена = Перечисления.ЭДО_НаправленияДокументов.Исходящий Тогда
		Если ДокументОснование <> Неопределено Тогда
			ДокументОбъект.ДокументОснование = ДокументОснование;
		Иначе
			ПолучитьДокументОснованиеИзКонтурEDI(ДокументОбъект);
			ДокументОснование = ДокументОбъект.ДокументОснование;
		КонецЕсли;	
		
		ДокументОбъект.Прочитан = Document.IsRead;
	КонецЕсли;
	
	// Сохраняем документ
	ДокументОбъект.Записать();
	
	// Создаем/обновляем пакет
	МЗ_Пакет.ИдентификаторПакета = ИдентификаторПакета;	
	МЗ_Пакет.КаналОбмена = ДокументОбъект.КаналОбмена;
	МЗ_Пакет.Направление = НаправлениеОбмена;
	МЗ_Пакет.Организация = Организация;
	МЗ_Пакет.КонтрагентЭДО = ДокументОбъект.КонтрагентЭДО;	
	
	МЗ_Пакет.Статус = ПолучитьСтатусПакетаОператор(МЗ_Пакет.ИдентификаторПакета);
	МЗ_Пакет.СтатусПакета = ПолучитьСтатусПакета(МЗ_Пакет.ИдентификаторПакета);
	
	Если DocumentEvent <> Неопределено Тогда
		МЗ_Пакет.ДатаПоследнегоСобытия	= DocumentEvent.Timestamp;
		МЗ_Пакет.ИдентификаторПоследнегоСобытия = DocumentEvent.EventId;
	Иначе
		Если НаправлениеОбмена = Перечисления.ЭДО_НаправленияДокументов.Исходящий Тогда
			МЗ_Пакет.ДатаПоследнегоСобытия = ТекущаяДата();		
		КонецЕсли;	
	КонецЕсли; 
	
	МЗ_Пакет.ПредставлениеДокументов = ЭДО_ОбщегоНазначения.ПолучитьПредставлениеДокументовПакета(МЗ_Пакет.ИдентификаторПакета);
	МЗ_Пакет.СуммаПакета = ПолучитьСуммуПакета(МЗ_Пакет.ИдентификаторПакета);
	
	// Сохраняем пакет
	МЗ_Пакет.Записать();
	
	Если НаправлениеОбмена = Перечисления.ЭДО_НаправленияДокументов.Исходящий Тогда
		Если ДокументОснование <> Неопределено И ЗначениеЗаполнено(ДокументОбъект.ТипДокумента.ТипДокумента) Тогда
			Запись = РегистрыСведений.ЭДО_СопоставлениеДокументов.СоздатьМенеджерЗаписи();
			Запись.Документ = ДокументОснование;
			Запись.ВидДокумента = ДокументОбъект.ТипДокумента.ТипДокумента;				
			Запись.ДокументЭДО = ДокументОбъект.Ссылка;
			Запись.Записать();  
			
			Попытка
				Справочники.АК_АлгоритмыРаспознаванияФайлов.СравнитьОбъектИФайл(ДокументОбъект.Ссылка, ДокументОснование); 
			Исключение						
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры 

Функция ЗагрузитьСобытие(Организация, DocumentEvent, КаталогЗагрузкиФайлов) Экспорт
	
	// Если диадок не вернул документ - идем дальше
	Попытка 
		Document = DocumentEvent.GetDocument();							
	Исключение
		//ЗаписьЖурналаРегистрации("ЭДО", УровеньЖурналаРегистрации.Ошибка, , , "Диадок. " + ОписаниеОшибки());							
		Возврат Неопределено;
	КонецПопытки; 
	
	// Загружаем только новые изменения	
	МЗ_Пакет = РегистрыСведений.ЭДО_Пакеты.СоздатьМенеджерЗаписи();
	
	ИдентификаторПакета = Document.DocumentId;	
	
	Если НЕ ПустаяСтрока(Document.PackageId) Тогда
		ИдентификаторПакета = Document.PackageId;
	КонецЕсли; 
	
	МЗ_Пакет.ИдентификаторПакета = ИдентификаторПакета;
	МЗ_Пакет.Прочитать();
	
	Если МЗ_Пакет.ДатаПоследнегоСобытия > DocumentEvent.Timestamp Тогда
		Возврат Неопределено; 
	КонецЕсли; 
	
	// Загружаем документ
	ЗагрузитьДокумент(Document, Организация, DocumentEvent, КаталогЗагрузкиФайлов);
	
	Возврат ИдентификаторПакета;
	
КонецФункции

Процедура ПерезагрузитьПакет(КэшДиадок, ИдентификаторПакета) Экспорт

	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЭДО_ВходящийДокумент.ИдентификаторДокумента,
	                      |	ЭДО_ВходящийДокумент.Организация
	                      |ИЗ
	                      |	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	                      |ГДЕ
	                      |	ЭДО_ВходящийДокумент.ИдентификаторПакета = &ИдентификаторПакета");
	
	Запрос.УстановитьПараметр("ИдентификаторПакета", ИдентификаторПакета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Организация = Выборка.Организация;
		
		НастройкиОрганизации = КэшДиадок.Организации[Организация];
		
		Если НастройкиОрганизации = Неопределено Тогда
			Сообщить("Для текущего пользователя не настроена возможность загрузки документов по организации " + Организация, СтатусСообщения.Важное);
			Возврат;	
		КонецЕсли;
		
		Organization = НастройкиОрганизации.Organization;
		
		Document = Organization.GetDocumentById(Выборка.ИдентификаторДокумента);
		
		ЗагрузитьДокумент(Document, Организация, , , Истина);
	КонецЦикла;  
	
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПОДПИСАНИЯ ДОКУМЕНТОВ

Процедура ЗаполнитьПодписанта(Signer, НастройкиОрганизации, ТипSigner = "Signer") Экспорт
	
	Если НЕ НастройкиОрганизации.ДанныеСотрудника.ПраваДоступа.CanSignDocuments Тогда
		Signer.Surname=		"-";
		Signer.FirstName=	"-";
		
	Иначе
		Signer.Surname = НастройкиОрганизации.ДанныеСотрудника.Фамилия;
		Signer.FirstName = НастройкиОрганизации.ДанныеСотрудника.Имя;
		Signer.Patronymic =	НастройкиОрганизации.ДанныеСотрудника.Отчество;
		Signer.JobTitle = НастройкиОрганизации.ДанныеСотрудника.Должность;
		
	КонецЕсли;
	
	Если ТипSigner = "Signer" Тогда
		Signer.Inn = НастройкиОрганизации.Organization.Inn;		
	КонецЕсли; 
	
КонецПроцедуры	

Функция УтвердитьОтклонитьДокумент(КэшДиадок, ИдентификаторДокумента, Утвердить, Комментарий = "") Экспорт

	Результат = Новый Структура("ОперацияВыполнена", Ложь);
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ЭДО_ВходящийДокумент.ИдентификаторДокумента,
	                      |	ЭДО_ВходящийДокумент.Организация,
	                      |	ЭДО_ВходящийДокумент.ПредставлениеДокумента,
	                      |	ЭДО_ВходящийДокумент.Статус.Статус КАК Статус
	                      |ИЗ
	                      |	Документ.ЭДО_ВходящийДокумент КАК ЭДО_ВходящийДокумент
	                      |ГДЕ
	                      |	ЭДО_ВходящийДокумент.ИдентификаторДокумента = &ИдентификаторДокумента");
	
	Запрос.УстановитьПараметр("ИдентификаторДокумента", ИдентификаторДокумента);
	
	ПараметрыДокумента = Запрос.Выполнить().Выбрать();
	
	Если НЕ ПараметрыДокумента.Следующий() Тогда
		Сообщить("Не найден входящий документ с идентификатором " + ИдентификаторДокумента);
		Возврат Результат;	
		
	ИначеЕсли ПараметрыДокумента.Статус <> Перечисления.ЭДО_СтатусыДокументов.Получен Тогда
		Сообщить("Документ должен находиться в статусе ""Получен""!", СтатусСообщения.Важное);
		Возврат Результат;	
		
	КонецЕсли;
	
	Организация = ПараметрыДокумента.Организация;
	
	НастройкиОрганизации = КэшДиадок.Организации[Организация];
	
	Если НастройкиОрганизации = Неопределено Тогда
		Сообщить("Для текущего пользователя не настроена возможность утверждения/отклонения документов по организации " + Организация, СтатусСообщения.Важное);
		Возврат Результат;	
	КонецЕсли;
	
	Organization = НастройкиОрганизации.Organization;
	
	Попытка 
		Document = Organization.GetDocumentById(ИдентификаторДокумента);

		Если Утвердить Тогда
			ReplySendTask = Document.CreateReplySendTask("AcceptDocument");			
			
			Если ReplySendTask.Content.type = "UniversalTransferDocumentBuyerTitle" Тогда
				ReplySendTask.Content.Creator = Organization.Name;
				ReplySendTask.Content.OperationContent = "Товары и услуги получены, работы приняты";
				
				ExtendedSigner = ReplySendTask.Content.AddSigner();
				ExtendedSigner.BoxId = Organization.Id;
				ExtendedSigner.CertificateThumbprint= Organization.Certificate.Thumbprint;
				
			ИначеЕсли ReplySendTask.Content.type = "XmlTorg12BuyerTitle" Тогда
				ReplySendTask.Content.ShipmentReceiptDate = НачалоДня(ТекущаяДата());
				ЗаполнитьПодписанта(ReplySendTask.Content.Signer, НастройкиОрганизации);				
			ИначеЕсли ReplySendTask.Content.type = "TovTorgBuyerTitle" Тогда
				
				ReplySendTask.Content.AcceptanceDate = НачалоДня(ТекущаяДата());
				ReplySendTask.Content.DocumentCreator = Organization.Name;
				ReplySendTask.Content.OperationContent = "Товары и услуги получены, работы приняты";
				
				ExtendedSigner = ReplySendTask.Content.AddSigner();
				ExtendedSigner.BoxId = Organization.Id;
				ExtendedSigner.CertificateThumbprint= Organization.Certificate.Thumbprint;

				
			ИначеЕсли ReplySendTask.Content.type = "XmlAcceptanceCertificateBuyerTitle" Тогда
				ReplySendTask.Content.SignatureDate = НачалоДня(ТекущаяДата()) = НачалоДня(ТекущаяДата());
				ЗаполнитьПодписанта(ReplySendTask.Content.Signer, НастройкиОрганизации);				
				ЗаполнитьПодписанта(ReplySendTask.Content.Official, НастройкиОрганизации, "Official");				
			ИначеЕсли  ReplySendTask.Content.type = "XmlAcceptanceCertificate552BuyerTitle" Тогда
				
				ReplySendTask.Content.AcceptanceDate = НачалоДня(ТекущаяДата());
				ReplySendTask.Content.DocumentCreator = Organization.Name;
				ReplySendTask.Content.OperationContent = "Товары и услуги получены, работы приняты";
				
				ExtendedSigner = ReplySendTask.Content.AddSigner();
				ExtendedSigner.BoxId = Organization.Id;
				ExtendedSigner.CertificateThumbprint= Organization.Certificate.Thumbprint;
				
				
			ИначеЕсли ReplySendTask.Content.type= "DocumentSignature" Тогда
				
			Иначе
				Сообщить("Возможность утверждения документов данного типа непредусмотрена!");
				Возврат Результат;
			КонецЕсли; 			
			
		Иначе
			Если Document.Type = "Nonformalized" Тогда
				Document.Reject(Комментарий);
				ReplySendTask = Неопределено;
			Иначе
				ReplySendTask = Document.CreateReplySendTask("RejectDocument");										
				ЗаполнитьПодписанта(ReplySendTask.Content.Signer, НастройкиОрганизации);				
				ReplySendTask.Content.Comment = Комментарий;
			КонецЕсли;
		КонецЕсли; 
		
		Если ReplySendTask <> Неопределено Тогда		
			ReplySendTask.Send();
		КонецЕсли;	
		
	Исключение
		ЭДО_ОбщегоНазначения.СообщитьОбОшибке("Не удалось утвердить документ " + ПараметрыДокумента.ПредставлениеДокумента + ". " + ОписаниеОшибки());
		
		Возврат Результат;
	КонецПопытки; 
	
	// Обновляем информацию по документу
	Document = Organization.GetDocumentById(ИдентификаторДокумента);
	ЗагрузитьДокумент(Document, Организация, , , Истина);
	
	Результат.ОперацияВыполнена = Истина;
	
	Возврат Результат;
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОТПРАВКИ ДОКУМЕНТА

Функция ОтправитьФайлЭДО(СтрукутраПараметров, ПараметрыЭД) Экспорт
	
	Результат = Истина;
	
	Возврат Результат;
КонецФункции	




