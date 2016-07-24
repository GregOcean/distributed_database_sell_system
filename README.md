# distributed_database_sell_system
A demo of online apple store sell system based on distributed mysql database. The distributing character is used to make data transfer faster.
苹果商店销售系统主要是面向苹果公司各个产品在中国的销售市场，用户可以选择在不同的站点，不同的门店购买不同的苹果产品。
我们一共在北京、上海、香港三个地方设置了站点，每个站点都有服务器和数据库，因此需要实现分布式数据库的管理。由于时间的限制，我们目前只做了这三个地点的苹果商店销售点，我们需要根据用户所在的地点，通过访问不同的URL让用户连接最近的服务器（商用环境下可基于LBS服务给这些URL排序推荐），从而在用户购买时让用户获得最佳的用户体验。
在分布透明性方面用户能感觉到的除了上述不同的URL外，还有一点就是注册环节需要先选择地理位置，即每个用户有一个“家乡”站点，在那儿对其识别，但登陆时经过家乡站点验证后的用户可以自由地在不同区域购买，即具有“穿越”的特性，一站识别，所有认可。

1.分布式数据库设计	
1.1 分布式数据库简述
分布式数据库系统是在集中式数据库系统的基础上发展起来的，是数据库技术和网络技术结合的产物。分布式数据库是基于计算机网络连接的集中式数据库的逻辑集合，它既保留了集中式数据库模式结构的特色，又比集中式数据库模式结构复杂，分布式数据库是多层级模式结构，主要包括全局外模式，全局概念模式，分片模式，分配模式，局部概念模式和局部内模式。分布式数据库主要分为：同构同质型，同构异质型，异构型。我们的系统采用的是同构同质型，既三个站点都是使用关系型数据库MySql。

1.2 全局数据模式
   分布式数据库的全局数据模式主要描述分布式数据库中全局数据的逻辑结构和数据特性，采用关系模型的全局概念模式一般由一组全局关系的基本定义（如关系名称、关系中的属性、每一属性的数据类型和长度等）以及完整性定定义（如
关系的主键、外键及完整性约束等）组成。

user: UId(varchar, key), UPwd(varchar),Location(varchar)
 
store: RId(int, key), RName(varchar), Location(varchar), RIntro(text), RImg(varchar)
 
commodity:FId(int, key), Rid(int, FK=store(RId)), FName(varchar), Price(money), FIntro(text), FImg(varchar)
（decimal小数点值为2）
 
orders: OId(int, key), UId(int, FK=user(UId)), FId(int, FK=commodity(FId)), RId(int, FK=store(Rid)), Number(int), Price(money), Location(varchar), Time(Date), State(varchar)
 

1.3 分布需求分析
由于时间有限，只简单实现了部分必要的应用：
1.	订单
a)	购买
b)	取消订单
c)	查看订单
2.	用户验证
a)	登陆
b)	注销
3.	查询商品
a)	查询某地区的苹果销售分店
b)	查询某分店的产品
4.	用户注册
a)	选择注册地区注册

1.4 分片设计
可按照地理位置对各实体进行水平分片
1．	store 按照 Location 水平分片
2．	commodity 按照所在分店的Location 导出水平分片
3．	user 按照所有出现的订单位置水平分片
对于垂直分片，唯一值得划分的是orders，然而orders只有在进行订单操作时才会涉及，此时访问订单内容的全部属性，因此无需垂直分片。
1.5 分配设计
store, commodity, orders各分片分配于所属区域，非冗余分配。
user可能在不同区域被访问，因此要进行冗余分配，同时分配在出现购买的区站点上。对于多副本的管理，策略如下：
	记录用户最后一次访问的站点，看作主站。如果当前用户不在主站登陆，则向主站请求用户信息进行更新，并将当前站点设为主站。否则，可直接进行获取到用户信息。

2.系统设计
2.1 系统结构
系统采用的是B/S结构，用户可以通过浏览器访问任意一个站点，实际应用中系统能为用户推荐连接最近的站点。
每个地区有若干门店，他们共同使用这个地区的一个数据库和对应的服务器群。每个地区有一个数据库，每个地区有一个或多个服务器（共同服务一个URL，即访问该地区的URL在DNS解析时能根据负载等情况导向不同的服务器），服务器也可以访问其他站点的数据库。
数据库中存储的是访问该站点使用最频繁的数据，从而提高了用户访问的速度。


2.2 服务器层次结构
三个站点服务器都是采用相同的层次结构。我们采用了MVC架构模式。
View层直接与页面显示相关，用于向用户显示信息，并获取用户在页面上的操作，传递给后台产生相应的响应。
Controller层接受View层的消息，并调用Service层的服务对用户的请求进行处理，再把处理后的消息传递给View层进行显示。
Service层主要是为Controller层提供服务， 还可以调用DAO层来对数据库进行增删改查操作。Service层的每一个服务都对应着数据库中的一个事务，在该层中对分布式数据库进行事务管理。
DAO层直接与数据库进行交互，主要是用于对数据库表格和Java对象之间进行映射，即把数据库表格中的内容封装成Java对象，或者把Java对象写入到数据库的表格中。该层提供了对数据库进行基础的增删改查操作的接口，为上层提供方便的服务。该层还负责对数据库进行分片处理，从分片配置文件中读取分片规则，根据规则对相应的数据库进行操作。

2.3 具体实现技术

•	在浏览器段与用户交互使用Javascript
•	接到用户表单请求，通过Java Servlet 中的HandleMapping对url进行解析，从而将不同的表单请求映射到不同的Controller处理。
•	Controller将表单中的数据通过JSON接口协议解析处来，并作为参数传递给Service层。不同的Controller调用不同的Service层服务组合完成不同的任务，返回不同的jsp页面，最终呈现给用户。
•	在服务层中完成分布式事务的执行，具体地，通过解析XML数据库配置文件并转化为Java类来完成分布式请求的判断和执行，通过JTA提供的注解实现了分布式事务，通过Atomikos分布式事务管理器保证了事务的安全性、崩溃恢复等基本特性。
•	DAO层完成数据库语句的执行，服务层通过DAO层的提供的接口完成分布式数据持久化的操作。
•	整个项目运行在Apache+Tomcat的服务器环境下。

3.开发与运行环境
•	编译环境：Eclipse J2EE Luna Release (4.4.0)
•	服务器：apache-tomcat-7.0.55
•	数据库：Mysql 5.5.20
•	相关Jar包：已包含在项目工程中。
•	运行配置：修改jdbc.properties中的数据库用户名、密码以及相应主机url即可。