#pragma version >0.3.10

struct Housing:
    hid: uint256
    location: String[100]
    start_date: uint256
    end_date: uint256
    price: uint256

struct Transportation:
    tid: uint256
    location: String[100]
    start_date: uint256
    end_date: uint256
    price: uint256

struct Guiding:
    gid: uint256
    location: String[100]
    start_date: uint256
    end_date: uint256
    price: uint256

struct PlannedTrip:
    tid: uint256
    gid: uint256
    hid: uint256
    location: String[100]
    start_date: uint256
    end_date: uint256
    price: uint256



houses: public(HashMap[uint256, Housing])
transports: public(HashMap[uint256, Transportation])
guides: public(HashMap[uint256, Guiding])
trips: public(HashMap[uint256, PlannedTrip])

house_counter: public(uint256)
transport_counter: public(uint256)
guide_counter: public(uint256)
trip_counter: public(uint256)




@external
def add_housing(hid: uint256, location: String[100], start_date: uint256, end_date: uint256, price: uint256):
    self.house_counter += 1
    self.houses[self.house_counter] = Housing(hid=hid, location=location,start_date=start_date,end_date=end_date,price=price)
    self.check_trips() 

@external
def add_transportation(tid: uint256, location: String[100], start_date: uint256, end_date: uint256, price: uint256):
    self.transport_counter += 1
    self.transports[self.transport_counter] = Transportation(tid=tid, location=location,start_date=start_date,end_date=end_date,price=price)
    self.check_trips() 

@external
def add_guiding(gid: uint256, location: String[100], start_date: uint256, end_date: uint256, price: uint256):
    self.guide_counter += 1
    self.guides[self.guide_counter] = Guiding(gid=gid, location=location,start_date=start_date,end_date=end_date,price=price)
    self.check_trips() 

@external
def add_planned_trip(tid: uint256, gid: uint256, hid: uint256, location: String[100], start_date: uint256, end_date: uint256, price: uint256):
    self.trip_counter += 1
    self.trips[self.trip_counter] = PlannedTrip(tid=tid,gid=gid,hid=hid,location=location,start_date=start_date,end_date=end_date, price=price)


@internal
def ending(a: uint256, b: uint256, c: uint256) -> uint256:
    return min(a,min( b, c))

@internal
def starting(a: uint256, b: uint256, c: uint256) -> uint256:
    return max(a,max( b, c))

@internal
def do_dates_overlap(start1: uint256, end1: uint256, start2: uint256, end2: uint256) -> bool:
    return start1 <= end2 and start2 <= end1







@deploy
def __init__():
    self.house_counter=0
    self.guide_counter=0
    self.transport_counter=0
    self.trip_counter=0

@external
def get_housing(i: uint256) ->(uint256,uint256, String[100], uint256, uint256, uint256): #String[100] : 
    house: Housing = self.houses[i]
    return (i,house.hid, house.location, house.start_date, house.end_date, house.price)
    #return house.location

@external
def get_transportation(i: uint256) ->(uint256,uint256, String[100], uint256, uint256, uint256): #String[100] : 
    trans: Transportation = self.transports[i]
    return (i,trans.tid, trans.location, trans.start_date, trans.end_date, trans.price)
    #return house.location

@external
def get_guiding(i: uint256) ->(uint256,uint256, String[100], uint256, uint256, uint256): #String[100] : 
    guide: Guiding = self.guides[i]
    return (i,guide.gid, guide.location, guide.start_date, guide.end_date, guide.price)
    #return house.location

@external
def get_planned_trip(i: uint256) ->(uint256,uint256,uint256,uint256, String[100], uint256, uint256, uint256): #String[100] : 
    trip: PlannedTrip = self.trips[i]
    return (i,trip.hid,trip.gid,trip.tid, trip.location, trip.start_date, trip.end_date, trip.price)
    #return house.location





@internal
def check_trips():
    for i: uint256 in range(1,100):
        house: Housing = self.houses[i]
        if house.hid == 0:
            continue

        for j: uint256 in range(1,100):  
            trans: Transportation = self.transports[j]
            if trans.tid == 0:
                continue
            if keccak256(house.location) == keccak256(trans.location) and self.do_dates_overlap(trans.start_date, trans.end_date, house.start_date, house.end_date):
                for k: uint256 in range(1, 100):
                    guidee: Guiding = self.guides[k]
                    if guidee.gid == 0:
                        continue
                    if keccak256(guidee.location) == keccak256(house.location) and self.do_dates_overlap(guidee.start_date, guidee.end_date, house.start_date, house.end_date):                               
                        start_date: uint256 = self.starting(guidee.start_date, trans.start_date, house.start_date)
                        end_date: uint256 = self.ending(guidee.end_date, trans.end_date, house.end_date)
                        exists: bool = False
                        
                        for v: uint256 in range(1, 100):
                            tripp: PlannedTrip = self.trips[v]
                            if tripp.hid == 0:
                                continue
                            if self.do_dates_overlap(start_date, end_date, tripp.start_date, tripp.end_date) or keccak256(guidee.location) == keccak256(tripp.location):
                                exists = True
                                break

                        if not exists:
                            self.trip_counter += 1
                            self.trips[self.trip_counter] = PlannedTrip(
                                tid=trans.tid,
                                gid= guidee.gid,
                                hid= house.hid,
                                location = guidee.location,
                                start_date= start_date,
                                end_date= end_date,
                                price=((trans.price + guidee.price + house.price) * (end_date - start_date))
                            )
                            self.remove_guiding(k)
                            self.remove_housing(i)
                            self.remove_transportation(j)




@internal
def remove_housing(id: uint256):
    self.houses[id] = Housing(hid=0, location="",start_date=0,end_date=0,price=0)

@internal
def remove_transportation(id: uint256):
    self.transports[id] = Transportation(tid=0, location="",start_date=0,end_date=0,price=0)


@internal
def remove_guiding(id: uint256):
    self.guides[id] = Guiding(gid=0, location="",start_date=0,end_date=0,price=0)


