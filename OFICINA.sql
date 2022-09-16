create datebase mechanical_workshop;
use mechanical_workshop;

create table customers (
		id_customer int primary key auto_increment,
        name_customer varchar (30),
        CPF char(11) unique,
        vehicle_model varchar (30),
        license_plate char(7) unique,
        customer_contact int 
);

insert into customers (name_customer, CPF, vehicle_model, license_plate,customer_contact) values
						('Nivaldo Beirao', '57828847504','fiesta','DGX9O35','997435764'),
                        ('Jose Maria', '47594421509','ix35','QTP5F71','968473139'),
                        ('Benedito Soares', '66804720911','XC60','CXZ7B41','997348980');

create table mechanics_team (
		id_mechanic int primary key auto_increment,
        name_mechanic varchar (30),
        address varchar (30),
        mechanical_specialty enum('Body shop','Electrical','Cooling','Motor','Gearbox')
);

insert into mechanics_team (name_mechanic,address,mechanical_specialty) values
								('Valter Santana', 'Rua Santa Rita 69','Body shop'),
                                ('Marcelo Ferreira', 'Rua Ubirajara 44', 'Motor'),
                                ('Dirceu Vieira','Rua Valdemar Ferraz', 'Electrical');
                                

create table service_request (
		id_os int primary key auto_increment,
        date_os date,
        status_os enum('analyzing','in_progress','waiting_for_approval','waiting_for_part','concluded'),
        completion_date date,
        valor float,
        type_os enum ('concert','revision'),
        description_service varchar (255),
        idcustomer_os int,
        idmechanic_os int,
        constraint fk_service_request_customer foreign key (idcustomer_os) references customers(id_customer),
        constraint fk_service_request_mechanic foreign key (idmechanic_os) references mechanics_team(id_mechanic)        
);

insert into service_request (date_os, status_os,completion_date,valor,type_os,description_service,idcustomer_os,idmechanic_os) values
							 ('2022-09-15', 'analyzing','2022-09-20','500','concert','Body shop at the door','1','1'),
                             ('2022-09-15', 'waiting_for_approval','2022-09-20','800','revision','engine failing','2','2'),
                             ('2022-09-15', 'waiting_for_approval','2022-09-20','200','concert','headlight does not light','3','3');
                             
create table labor(
		id_labor int primary key auto_increment,
        valor_labor float,
        idmechanic_responsible int,
        idbudget_labor int,
        constraint fk_labor_mechanic foreign key (idmechanic_responsible) references mechanics_team(id_mechanic),
        constraint fk_labor_budget foreign key (idbudget_labor) references budget(Id_budget)
);

insert into labor (valor_labor,idmechanic_responsible,idbudget_labor) values
						('150','1','1'),
                        ('200','2','2'),
                        ('230','3','3');
 
create table budget(
		Id_budget int primary key auto_increment,
        number_os int,
        valor_budget float,
        id_customer_budget int,
        constraint fk_budget_number_os foreign key (number_os) references service_request(id_os),
		constraint fk_budget_id_customer foreign key (id_customer_budget) references customers(id_customer)
);

insert into budget (number_os ,valor_budget, id_customer_budget)values
						('1','200',1),
                        ('2','500',2),
                        ('3','500',3);

create table part(
		id_part int primary key auto_increment,
        description_part varchar (255),
        valor_part float,
        idbudget_part int,
        constraint fk_part_idbudget_part foreign key (idbudget_part) references budget(Id_budget)
);

insert into part (description_part,valor_part,idbudget_part) values
					('right side mirror','65','1'),
                    ('engine head','330','2'),
                    ('left headlight','295','3');
 
 -- sort customers by name
select * from customers
order by name_customer;

-- customer work order status with service value
select customers.name_customer, budget.valor_budget, service_request.status_os from customers
inner join budget
on customers.id_customer = budget.id_customer_budget
join service_request
on service_request.id_os = budget.id_customer_budget;

-- type of service requested by the customer, with the name of the responsible mechanic
select customers.name_customer, service_request.description_service, mechanics_team.name_mechanic from customers
inner join service_request
on customers.id_customer = service_request.idcustomer_os
join mechanics_team
on mechanics_team.id_mechanic = service_request.idmechanic_os;

-- specialty of each mechanic 
select mechanics_team.name_mechanic, mechanics_team.mechanical_specialty from  mechanics_team;

-- value of each piece for each customer request 
select part.description_part, part.valor_part, budget.id_customer_budget from budget
inner join part
on budget.Id_budget = part.idbudget_part;