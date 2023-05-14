# Реферат

## по курсу "Логическое программирование"

### студент: Фадеев Д.В.

## Логические языки и базы данных

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Введение

Выбирая тему реферата, мой взгляд срузу же пал на "Логические языки и базы данных", что-то другое уже не могло так сильно привлечь. Мне эта тема не просто интересна, она затрагивает технологию особенно близкую моему сердцу, с которой я взаимодейсвтвую уже почти 4 года - это базы данных. Думаю, было бы полезно изучить такую тему, так как она лично для меня нова, ранее о ней я не задумывался. Особенно полезно для общего развития взглянуть на уже привычные, знакомые вещи под новым углом.

Но невозможно говорить об общих признаках и связях между двумя вещами, если мы с ними близко не знакомы. Давайте немного погрузимся в струкутру современных логических языков и баз данных, взглянем на их определения, философию и математическое представление, чтобы затем в этой куче характеристик найти общие черты, на основе которых построим весь вывод этого эссе.

## Логические языки программирования
В течение курса мы изучали язык Prolog, поэтому на него будем ориентироваться больше всего. Любая логичская программа состоит из фактов и предикатов, на основе которых делаются вычисления и выводы. Подробно с математематической моделью такого программирования можно познкомиться на 1 курсе университета  вдисциплине "Дискретная математика". Там же описаны некотрые конструкции таких логических языков, например рекурсии.

Одним из важных преимуществ данной парадигмы является высокий уровень машинной независимости, а также возможность возврата к предыдущей подцели при отрицательном результате анализа одного из вариантов в процессе поиска решения, например, при игре в шахматы. Это избавляет от необходимости полного перебора вариантов и повышает эффективность реализации данной парадигмы.

Написание программы на таких языках схоже с обучением ребенка, мы ему даём факты и некоторые приспособления, с помощью которых он может из фактов выводить что-то новое. Единственная проблема работа логических программ, как и обучение ребёнка, процесс не быстрый. Сейчас объясню почему.

В логических языках программирования, например тот же Prolog, вшиты деревья вывода, позволяющие перебирать все возможные варианты значений переменных. Такая структура позволяет скрыть при решении логической задачи последовательность действий, которую должен выполнить компьютер, оставляя на пользователе только задачу правильно составить правила, по которым выполняется условие. Тоесть пролог декларативный язык программирования, который еще является и полным. Поэтому он так хорошо в логических задачах, в отличие от императивных языков, в которых нам явно пришлось бы писать дерево решений.

## Базы данных
Базы данных в особом представлении не нуждаются, о них слышали все, даже люди не близкие к теме IT, так как в последнее время всё чаще в СМИ поднимается тема безопасности личной информации. Базы данных имеют множество различных представлений, концепций и реализаций, но король из них все - это реляционные базы данных, ставшими самыми популярными. Сама концепция хранения информации в таблицах людям интуитивно понятна и таким образом можно очень компактно хранить гигантские объёмы информации. 

Для работы с СУБД был создан язык SQL. Его старались сделать как можно проще, чтобы даже секретари могли работать с базами данных, но, как можем увидеть, этого не произошло. Язык SQL через ключевые слова позволяет нам строить запросы к СУБД, которые проводят какие то действия над ней. Тоесть нам не нужно описывать как работать с базой данных, SQL позволяет описать только конечный результат нашего запроса. Поэтому он декларативный язык и полные программы на нём писать сложно, поэтому в него встраивают императивные вызовы.

SQL - это универсальный язык работы с разными СУБД, поэтому реализация ваших запросов к ней зависит на прямую от разработчиков базы данных и может отличаться от одного разработчика к другому.

## Синтез баз данных и логичсеких языков
Проанализировав два предыдущих раздела, можем заметить, что язык SQL и логические языки являются декларативными языками. В них нам не требуется прописывать всю последовательность действий, которую должен выполнить компьютер или СУБД. Также в основе логических языков лежат факты, с которыми можно оперировать. Они представляют из себя наборы одинаковой длины и структуры для каждого семейства фактов содержащие значения разных типов. В реляционных базах данных мы работаем с таблицами и записями в них. В каждой таблице есть стобцы, которые обязательно заполнены(или нет) для всех записей в этой таблице. То есть между фактами в логических языках и записями в БД можно поставить соотвествие.

Давайте зададимся вопросом, раз базы данных и языки программирования так похожи, значит должен существовать какой-то их синтез? И сразу же поступит ответ - Да! Причём в языке Prolog мы можем использовать БД для оптимизации вычислений. Иногда возникает ситуация, когда одну и ту же цель приходится достигать снова и снова. Повторений легко избежать, если запоминать каждое вновь вычисленное значение в БД.

Но кроме того, существуют базы данных, которые используют возможности логических языков максимально полно, они буквально "пропитаны" логическим программированием. Давайте рассмотрим несколько примеров.

## Дедуктивные базы данных 
Дедуктивные базы данных (далее ДБД) являются зачастую надстройкой над реляционной СУБД, используя её как базу фактов, посылая к ней запросы в формате пакетов. Важным отличием от обычных БД выступает то, что ДБД для доказательства правил может использовать рекурсии, что очень полезно при составлении рекурсивных запросов. Но, к сожалению, это серьезный удар по скорости работы программ и выполнению запросов, что критично при работе с большими данными. Еще важной особенностью является хранение выводимых правил. Стандартные СУБД такого не могут.

Для работы с ДБД был написан своя версия Prolog - это Datalog. Внутри себя он имеет несколько ограничений, который упрощают работу с ним. Наверное одно из самых важных ограничений - запрос на конечном множестве обязательно должен завершиться. Также этот язык не приемлет сложных термов в аргументах.



## Заключение

В данной работе я познакомился с историей развития шахматных движков, основных шахматных алгоритмов и влияние на развитие компьютерной техники. Работа оказалось очень интересной, ведь шахматы столь давно существующая игра, до сих пор не была полностью изучена. Также при изучении материала меня поразило влияние шахмат, какой немыслимый фурор произвела победа DeepBlue над Каспаров. После этой работы хочется еще раз окунуться в мир этой удивительной игры. Также я привел описание простейшей шахматной программы на прологе. Конечно, написать подобную программу будет несколько тяжелее на логических языках программирования, но это интересная задачка покажет всю мощность пролога в решении задач поиска.

## Список литературы

1. Корнилов Е.Н. - "Программирование шахмат и других логических игр"
2. Сошников Д.В. - "Парадигма логического программирования"
3. Клоксин У. Мелиш К. - "Программирование на языке Пролог"
4. Братко И. - "Программирование на языке Пролог для алгоритмов искуственного интеллекта"
5. Интернет ресурс - "Википедия"