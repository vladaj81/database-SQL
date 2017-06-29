create database APN;
go
use APN;
go

/* TABELE */

create table kategorija(
kategorija_id int identity(1,1) not null,
vrsta nvarchar(30) not null
)

create table nekretnina(
nekretnina_id int identity(1,1) not null,
zaposleni_id int not null,
prodavac_id int not null,
kategorija_id int not null,
lokacija_id int not null,
adresa nvarchar(50) not null,
kvadratura nvarchar(10) not null,
cena nvarchar(20) not null,
cena_sa_popustom nvarchar(20) not null
)

create table lokacija(
lokacija_id int identity(1,1) not null,
naziv_lokacije nvarchar(30) not null
)

create table ugovor(
ugovor_id int identity(1,1) not null,
kupac_id int not null,
nekretnina_id int not null,
datum_overe date not null,
)

create table prodavac(
prodavac_id int identity(1,1) not null,
ime nvarchar(30) not null,
prezime nvarchar(30) not null,
jmbg bigint not null,
adresa nvarchar(50) not null,
broj_telefona nvarchar(20) not null,
)

create table kupac(
kupac_id int identity(1,1) not null,
ime nvarchar(30) not null,
prezime nvarchar(30) not null,
jmbg bigint not null,
adresa nvarchar(50) not null,
broj_telefona nvarchar(20) not null
)

create table zaposleni(
zaposleni_id int identity(1,1) not null,
vrsta_posla nvarchar(30) not null,
ime nvarchar(30) not null,
prezime nvarchar(30) not null,
jmbg bigint not null,
adresa nvarchar(50) not null,
broj_telefona nvarchar(20) not null
)

create table agent(
agent_id int identity(1,1) not null,
zaposleni_id int not null
)

create table administrativno_osoblje(
administrativno_osoblje_id int identity(1,1) not null,
zaposleni_id int not null
)

create table sastanak(
sastanak_id int identity(1,1) not null,
agent_id int not null,
zaposleni_id int not null,
kupac_id int not null,
nekretnina_id int not null,
datum_sastanka date not null,
ishod nvarchar(20) not null
)

create table agent_kategorija(
agent_kategorija_id int identity(1,1) not null,
agent_id int not null,
zaposleni_id int not null,
kategorija_id int not null,
)

create table agent_lokacija(
agent_lokacija_id int identity(1,1) not null,
agent_id int not null,
zaposleni_id int not null,
lokacija_id int not null,
) 

/* PRIMARNI KLJUCEVI */

alter table kategorija
add constraint PK_kategorija_id primary key(kategorija_id)

alter table lokacija
add constraint PK_lokacija_id primary key(lokacija_id)

alter table nekretnina
add constraint PK_nekretnina_id primary key(nekretnina_id)

alter table prodavac
add constraint PK_prodavac_id primary key(prodavac_id)

alter table kupac
add constraint PK_kupac_id primary key(kupac_id)

alter table zaposleni
add constraint PK_zaposleni_id primary key(zaposleni_id)

/* FOREIGN KEYS */

alter table nekretnina
add constraint FK_zaposleni_nekretnina foreign key(zaposleni_id)
references zaposleni(zaposleni_id)

alter table nekretnina
add constraint FK_prodavac_nekretnina foreign key(prodavac_id)
references prodavac(prodavac_id)

alter table nekretnina
add constraint FK_kategorija_nekretnina foreign key(kategorija_id)
references kategorija(kategorija_id)

alter table nekretnina
add constraint FK_lokacija_nekretnina foreign key(lokacija_id)
references lokacija(lokacija_id)

/* KOMPOZITNI KLJUCEVI */

alter table ugovor
add constraint FK_kupac_ugovor foreign key(kupac_id)
references kupac(kupac_id)

alter table ugovor
add constraint FK_nekretnina_ugovor foreign key(nekretnina_id)
references nekretnina(nekretnina_id)

alter table ugovor
add constraint PK_sklopljen_ugovor primary key(ugovor_id,kupac_id,nekretnina_id)


alter table agent
add constraint FK_zaposlen foreign key(zaposleni_id)
references zaposleni(zaposleni_id)

alter table agent
add constraint PK_zaposlen_agent primary key(agent_id,zaposleni_id)


alter table administrativno_osoblje
add constraint FK_zaposleni foreign key(zaposleni_id)
references zaposleni(zaposleni_id)

alter table administrativno_osoblje
add constraint PK_zaposleni_adm primary key(administrativno_osoblje_id,zaposleni_id)


alter table agent_lokacija
add constraint FK_zaposleni_lokacija foreign key(agent_id,zaposleni_id)
references agent(agent_id,zaposleni_id)

alter table agent_lokacija
add constraint FK_agent_lok foreign key(lokacija_id)
references lokacija(lokacija_id)

alter table agent_lokacija
add constraint PK_agent_lokacija primary key
(agent_lokacija_id,agent_id,zaposleni_id,lokacija_id)


alter table agent_kategorija
add constraint FK_zaposleni_kategorija foreign key(agent_id,zaposleni_id)
references agent(agent_id,zaposleni_id)

alter table agent_kategorija
add constraint FK_agent_kateg foreign key(kategorija_id)
references kategorija(kategorija_id)

alter table agent_kategorija
add constraint PK_agent_kategorija primary key
(agent_kategorija_id,agent_id,zaposleni_id,kategorija_id)


alter table sastanak
add constraint FK_agent_sastanak foreign key(agent_id,zaposleni_id)
references agent(agent_id,zaposleni_id)

alter table sastanak
add constraint FK_kupac_sastanak foreign key(kupac_id)
references kupac(kupac_id)

alter table sastanak
add constraint FK_nekretnina_sastanak foreign key(nekretnina_id)
references nekretnina(nekretnina_id)

alter table sastanak 
add constraint PK_sastanak_agent_kupac primary key
(sastanak_id,agent_id,zaposleni_id,kupac_id,nekretnina_id)

go

/* PROCEDURE INSERT,UPDATE I DELETE: */

/* TABELA KATEGORIJA */

create procedure insert_kategorija(
@pvrsta nvarchar(30)
)
as
begin
	begin tran
		insert into kategorija(vrsta)
		values(@pvrsta)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_kategorija(
@pkategorija_id int,
@pvrsta nvarchar(30)
)
as
begin
	begin tran
		update kategorija
		set vrsta=@pvrsta
		where kategorija_id=@pkategorija_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_kategorija(
@pkategorija_id int
)
as
begin
	begin tran
		delete from kategorija	
		where kategorija_id=@pkategorija_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA LOKACIJA */ 

create procedure insert_lokacija(
@pnaziv_lokacije nvarchar(30)
)
as
begin
	begin tran
		insert into lokacija(naziv_lokacije)
		values(@pnaziv_lokacije)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_lokacija(
@plokacija_id int,
@pnaziv_lokacije nvarchar(30)
)
as
begin
	begin tran
		update lokacija
		set naziv_lokacije=@pnaziv_lokacije
		where lokacija_id=@plokacija_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_lokacija(
@plokacija_id int
)
as
begin
	begin tran
		delete from lokacija	
		where lokacija_id=@plokacija_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA ZAPOSLENI */

create procedure insert_zaposleni(
@pvrsta_posla nvarchar(30),
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		insert into zaposleni(vrsta_posla,ime,prezime,jmbg,adresa,broj_telefona)
		values(@pvrsta_posla,@pime,@pprezime,@pjmbg,@padresa,@pbroj_telefona)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_zaposleni(
@pzaposleni_id int,
@pvrsta_posla nvarchar(30),
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		update zaposleni
		set vrsta_posla=@pvrsta_posla,ime=@pime,prezime=@pprezime,jmbg=@pjmbg,
		adresa=@padresa,broj_telefona=@pbroj_telefona
		where zaposleni_id=@pzaposleni_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_zaposleni(
@pzaposleni_id int
)
as
begin
	begin tran
		delete from zaposleni
		where zaposleni_id=@pzaposleni_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA PRODAVAC */

create procedure insert_prodavac(
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		insert into prodavac(ime,prezime,jmbg,adresa,broj_telefona)
		values(@pime,@pprezime,@pjmbg,@padresa,@pbroj_telefona)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_prodavac(
@pprodavac_id int,
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		update prodavac
		set ime=@pime,prezime=@pprezime,jmbg=@pjmbg,adresa=@padresa,broj_telefona=@pbroj_telefona
		where prodavac_id=@pprodavac_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_prodavac(
@pprodavac_id int
)
as
begin
	begin tran
		delete from prodavac
		where prodavac_id=@pprodavac_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA KUPAC */

create procedure insert_kupac(
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		insert into kupac(ime,prezime,jmbg,adresa,broj_telefona)
		values(@pime,@pprezime,@pjmbg,@padresa,@pbroj_telefona)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_kupac(
@pkupac_id int,
@pime nvarchar(30),
@pprezime nvarchar(30),
@pjmbg bigint,
@padresa nvarchar(50),
@pbroj_telefona nvarchar(20)
)
as
begin
	begin tran
		update kupac
		set ime=@pime,prezime=@pprezime,jmbg=@pjmbg,adresa=@padresa,broj_telefona=@pbroj_telefona
		where kupac_id=@pkupac_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_kupac(
@pkupac_id int
)
as
begin
	begin tran
		delete from kupac
		where kupac_id=@pkupac_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA NEKRETNINA */

create procedure insert_nekretnina(
@pzaposleni_id int,
@pprodavac_id int,
@pkategorija_id int,
@plokacija_id int,
@padresa nvarchar(50),
@pkvadratura nvarchar(10),
@pcena nvarchar(20),
@pcena_sa_popustom nvarchar(20)
)
as
begin
	begin tran
		insert into nekretnina(zaposleni_id,prodavac_id,kategorija_id,lokacija_id,
			adresa,kvadratura,cena,cena_sa_popustom)
		values(@pzaposleni_id,@pprodavac_id,@pkategorija_id,@plokacija_id,@padresa,
		@pkvadratura,@pcena,@pcena_sa_popustom)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_nekretnina(
@pnekretnina_id int,
@pzaposleni_id int,
@pprodavac_id int,
@pkategorija_id int,
@plokacija_id int,
@padresa nvarchar(50),
@pkvadratura nvarchar(10),
@pcena nvarchar(20),
@pcena_sa_popustom nvarchar(20)
)
as
begin
	begin tran
		update nekretnina
		set zaposleni_id=@pzaposleni_id,prodavac_id=@pprodavac_id,kategorija_id=@pkategorija_id,
		lokacija_id=@plokacija_id,adresa=@padresa,kvadratura=@pkvadratura,
		cena=@pcena,cena_sa_popustom=@pcena_sa_popustom
		where nekretnina_id=@pnekretnina_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_nekretnina(
@pnekretnina_id int
)
as
begin
	begin tran
		delete from nekretnina
		where nekretnina_id=@pnekretnina_id
	
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA AGENT */

create procedure insert_agent(
@pzaposleni_id int
)
as
begin
	begin tran
		insert into agent(zaposleni_id)
		values(@pzaposleni_id)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_agent(
@pagent_id int,
@pzaposleni_id int
)
as
begin
	begin tran
		update agent
		set zaposleni_id=@pzaposleni_id
		where agent_id=@pagent_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_agent(
@pagent_id int
)
as
begin
	begin tran
		delete from agent
		where agent_id=@pagent_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA ADMINISTRATIVNO OSOBLJE */

create procedure insert_administrativno_os(
@pzaposleni_id int
)
as
begin
	begin tran
		insert into administrativno_osoblje(zaposleni_id)
		values(@pzaposleni_id)
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_administrativno_os(
@padministrativno_osoblje_id int,
@pzaposleni_id int
)
as
begin
	begin tran
		update administrativno_osoblje
		set zaposleni_id=@pzaposleni_id
		where administrativno_osoblje_id=@padministrativno_osoblje_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_administrativno_os(
@padministrativno_osoblje_id int
)
as
begin
	begin tran
		delete from administrativno_osoblje
		where administrativno_osoblje_id=@padministrativno_osoblje_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA UGOVOR */

create procedure insert_ugovor(
@pkupac_id int,
@pnekretnina_id int,
@pdatum_overe date
)
as
begin
	begin tran
		insert into ugovor(kupac_id,nekretnina_id,datum_overe)
		values(@pkupac_id,@pnekretnina_id,@pdatum_overe)

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_ugovor(
@pugovor_id int,
@pkupac_id int,
@pnekretnina_id int,
@pdatum_overe date
)
as
begin
	begin tran
		update ugovor
		set kupac_id=@pkupac_id,nekretnina_id=@pnekretnina_id,datum_overe=@pdatum_overe
		where ugovor_id=@pugovor_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_ugovor(
@pugovor_id int
)
as
begin
	begin tran
		delete from ugovor
		where ugovor_id=@pugovor_id

		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA AGENT_KATEGORIJA */

create procedure insert_agent_kategorija(
@pagent_id int,
@pzaposleni_id int,
@pkategorija_id int
)
as
begin
	begin tran
		insert into agent_kategorija(agent_id,zaposleni_id,kategorija_id)
		values(@pagent_id,@pzaposleni_id,@pkategorija_id)
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_agent_kategorija(
@pagent_kategorija_id int,
@pagent_id int,
@pzaposleni_id int,
@pkategorija_id int
)
as
begin
	begin tran
		update agent_kategorija
		set agent_id=@pagent_id,zaposleni_id=@pzaposleni_id,kategorija_id=@pkategorija_id
		where agent_kategorija_id=@pagent_kategorija_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_agent_kategorija(
@pagent_kategorija_id int
)
as
begin
	begin tran
		delete from agent_kategorija
		where agent_kategorija_id=@pagent_kategorija_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA AGENT_LOKACIJA */

create procedure insert_agent_lokacija(
@pagent_id int,
@pzaposleni_id int,
@plokacija_id int
)
as
begin
	begin tran
		insert into agent_lokacija(agent_id,zaposleni_id,lokacija_id)
		values(@pagent_id,@pzaposleni_id,@plokacija_id)
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_agent_lokacija(
@pagent_lokacija_id int,
@pagent_id int,
@pzaposleni_id int,
@plokacija_id int
)
as
begin
	begin tran
		update agent_lokacija
		set agent_id=@pagent_id,zaposleni_id=@pzaposleni_id,lokacija_id=@plokacija_id
		where agent_lokacija_id=@pagent_lokacija_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_agent_lokacija(
@pagent_lokacija_id int
)
as
begin
	begin tran
		delete from agent_lokacija
		where agent_lokacija_id=@pagent_lokacija_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

/* TABELA SASTANAK */

create procedure insert_sastanak(
@pagent_id int,
@pzaposleni_id int,
@pkupac_id int,
@pnekretnina_id int,
@pdatum_sastanka date,
@pishod nvarchar(20)
)
as
begin
	begin tran
		insert into sastanak(agent_id,zaposleni_id,kupac_id,nekretnina_id,datum_sastanka,ishod)
		values(@pagent_id,@pzaposleni_id,@pkupac_id,@pnekretnina_id,@pdatum_sastanka,@pishod)
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure update_sastanak(
@psastanak_id int,
@pagent_id int,
@pzaposleni_id int,
@pkupac_id int,
@pnekretnina_id int,
@pdatum_sastanka date,
@pishod nvarchar(20)
)
as
begin
	begin tran
		update sastanak
		set agent_id=@pagent_id,zaposleni_id=@pzaposleni_id,kupac_id=@pkupac_id,
		nekretnina_id=@pnekretnina_id,datum_sastanka=@pdatum_sastanka,ishod=@pishod
		where sastanak_id=@psastanak_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

go

create procedure delete_sastanak(
@psastanak_id int
)
as
begin
	begin tran
		delete from sastanak
		where sastanak_id=@psastanak_id
		
		if @@error <>0
			begin
				rollback
			end
		else
			begin
				commit
			end 
end

/* PROBA */


--exec insert_kategorija N'Kuca'

--exec update_kategorija 3,N'Trosoban'

--exec delete_kategorija 5

--select * from kategorija


--exec insert_lokacija N'Karaburma'

--exec update_lokacija 3,N'Karaburma'

--exec delete_lokacija 5

--select * from lokacija


--exec insert_zaposleni N'Adm_radnik',N'Nikola',N'Jovanovic',N'1310983715047',N'Vojvode_Stepe_16',N'061/332-14-89'

--exec update_zaposleni 3,N'Adm_radnik',N'Nikola',N'Jovanovic',N'1310983715047',N'Vojvode_Stepe_17',N'061/332-14-89'

--exec delete_zaposleni 4

--select * from zaposleni


--exec insert_prodavac N'Mirka',N'Vasiljevic',N'2408985716435',N'Milesevska_15',N'065/535-11-09'

--exec update_prodavac 3,N'Milan',N'Kalinic',N'1508979715324',N'Milesevska_6',N'065/159-11-11'

--exec delete_prodavac 5

--select * from prodavac


--exec insert_kupac N'Miladin',N'Kocic',N'1512985715225',N'Brace_Grim_12',N'062/525-01-02'

--exec update_kupac 4,N'Jovan',N'Stojkovic',N'1406983716346',N'Brace_Grim_12',N'064/224-38-65'

--exec delete_kupac 5

--select * from kupac


--exec insert_nekretnina 2,4,4,4,N'Cvijiceva_55',N'125m2',N'112000_eur',N'108000_eur'

--exec update_nekretnina 3,2,3,3,3,N'Save_Mrkalja_11',N'82m2',N'80000_eur',N'bez_popusta'

--exec delete_nekretnina 5

--select * from nekretnina


--exec insert_agent 2

--exec update_agent 2,2

--exec delete_agent 4

--select * from agent


--exec insert_administrativno_os 3

--exec update_administrativno_os 2,1

--exec delete_administrativno_os 2

--select * from administrativno_osoblje


--exec insert_ugovor 4,4,'2014-10-18'

--exec update_ugovor 2,2,2,'2014-10-26'

--exec delete_ugovor 5

--select * from ugovor


--exec insert_agent_kategorija 2,2,4

--exec update_agent_kategorija 9,2,2,3

--exec delete_agent_kategorija 9

--select * from agent_kategorija


--exec insert_agent_lokacija 2,2,4

--exec update_agent_lokacija 4,1,1,2

--exec delete_agent_lokacija 9

--select * from agent_lokacija


--exec insert_sastanak 2,2,1,4,'2014-03-15',N'kupuje'

--exec update_sastanak 4,1,1,1,4,'2015-01-09',N'razmislice'

--exec delete_sastanak 9

--select * from sastanak     

--select * from ugovor


----select * from agent
----select * from lokacija
----select * from kupac
----select * from nekretnina
----select * from agent_lokacija

--update sastanak
--set ishod=N'razmislice' where sastanak_id between 17 and 20




































