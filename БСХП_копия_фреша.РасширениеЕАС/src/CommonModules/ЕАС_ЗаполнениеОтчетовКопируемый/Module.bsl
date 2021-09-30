#Область ПрограммныйИнтерфейс

Функция ЗначениеПараметраЗаполнения(Объект, ИмяПараметра) Экспорт
	ПараметрыЗаполненияСтроки = Объект.ПараметрыЗаполнения.НайтиСтроки(Новый Структура("Имя", ИмяПараметра));
	Если ПараметрыЗаполненияСтроки.Количество() > 0 Тогда
		ПараметрЗаполнения = ПараметрыЗаполненияСтроки[0];
		Если Не ПустаяСтрока(ПараметрЗаполнения.Значение) Тогда
			СохраненноеЗначение = ЗначениеИзСтрокиВнутр(ПараметрЗаполнения.Значение);
			Если ПараметрЗаполнения.Список И ТипЗнч(СохраненноеЗначение) = Тип("СписокЗначений") Тогда
				Возврат СохраненноеЗначение.ВыгрузитьЗначения();
			Иначе	
				Возврат СохраненноеЗначение;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
КонецФункции

Функция УстановитьРезультатВычисления(НачальнаяТаблица, СтруктураСтроки, Знач РезультатВычисления, Суммировать = Ложь) Экспорт
	СтрокиТаблицы = НачальнаяТаблица.НайтиСтроки(СтруктураСтроки);
	
	Если СтрокиТаблицы.Количество() > 0 Тогда
		СтрокаТаблицы = СтрокиТаблицы[0];
	Иначе
		СтрокаТаблицы = НачальнаяТаблица.Добавить(); 
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтруктураСтроки);
	КонецЕсли;	
	Если ТипЗнч(РезультатВычисления) <> Тип("Число") Тогда
		РезультатВычисления = 0;
	КонецЕсли;	
	СтрокаТаблицы.РезультатВычисления = ?(Суммировать, СтрокаТаблицы.РезультатВычисления + РезультатВычисления, РезультатВычисления);  
	Возврат СтрокаТаблицы; 
КонецФункции

Процедура ФорматированиеЗначенийВычислений(ТаблицаРасчетов, СтруктураСтроки, ВыборкаПолейШаблона) Экспорт
	
	СтрокиПолей = Новый Соответствие;
	СсылкиПолей = Новый Массив;
	Для НомерСтроки = 0 По ТаблицаРасчетов.Количество() - 1 Цикл
		СтрокаРасчетов = ТаблицаРасчетов[НомерСтроки];
		ЗаполнитьЗначенияСвойств(СтруктураСтроки, СтрокаРасчетов);
		ВыборкаПолейШаблона.Сбросить();
		Если ВыборкаПолейШаблона.НайтиСледующий(СтруктураСтроки) Тогда
			СсылкиПолей.Добавить(ВыборкаПолейШаблона.Ссылка);
			СтрокиПолей.Вставить(ВыборкаПолейШаблона.Ссылка, НомерСтроки);
		КонецЕсли;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПоляФормШаблонов.ТочностьЧисла КАК ТочностьЧисла,
		|	ПоляФормШаблонов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЕАС_ПоляФормШаблонов КАК ПоляФормШаблонов
		|ГДЕ
		|	ПоляФормШаблонов.Ссылка В(&Ссылки)";
	
	Запрос.УстановитьПараметр("Ссылки", СсылкиПолей);
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		НомерСтроки = СтрокиПолей.Получить(РезультатЗапроса.Ссылка);
		Если НомерСтроки <> Неопределено Тогда
			СтрокаРасчетов = ТаблицаРасчетов[НомерСтроки];
			СтрокаРасчетов.РезультатВычисления = Окр(СтрокаРасчетов.РезультатВычисления, РезультатЗапроса.ТочностьЧисла);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьАлгоритмБезопасно(Объект, Алгоритм, ВыборкаПолейШаблона, НачальнаяТаблица = Неопределено, СтруктураСтроки = Неопределено, РезультатРасчета = Неопределено) Экспорт
	Если ЗначениеЗаполнено(Алгоритм) Тогда
		НачатьТранзакцию();
		УстановитьБезопасныйРежим(Истина);
		Попытка
			Выполнить(Алгоритм);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
			ЗаписьЖурналаРегистрации("ЕАС" + "." + "ОшибкаАлгоритма", 
				УровеньЖурналаРегистрации.Ошибка, Метаданные.Документы.ЕАС_ОтчетыИнтеграции, Объект.Ссылка,
				СтрШаблон("Ошибка выполнения алгоритма: %1", ПредставлениеОшибки));
			ОбщегоНазначения.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;	
		УстановитьБезопасныйРежим(Ложь);
		ОтменитьТранзакцию(); // для безопасности (невозможно изменить базу)
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 
                                                     
