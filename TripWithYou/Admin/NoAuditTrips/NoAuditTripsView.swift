//
//  NoAuditTripsView.swift
//  TripWithYou
//
//  Created by 吕海锋 on 2024/4/23.
//

import SwiftUI

struct NoAuditTripsView: View {
    @StateObject private var viewModel: NoAuditTripsViewModel = NoAuditTripsViewModel()
    @StateObject private var mViewModel: MyPostTripsViewModel = MyPostTripsViewModel()
    var body: some View {
        List(viewModel.noAuditTripsArray, id: \.tripId) { trip in
            NavigationLink(destination: SubscribesUserInfoListView(viewModel: mViewModel, tripId: trip.tripId)) {
                NoAuditTripItemView(trip: trip, viewModel: viewModel)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        
                        Button {
                            viewModel.updateTripAuditStatus(tripId: trip.tripId, state: 1)
                        } label: {
                            Label("通过", systemImage: "person.badge.plus")
                        }
                        .tint(.green)

                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            viewModel.updateTripAuditStatus(tripId: trip.tripId, state: 2)
                        } label: {
                            Label("不通过", systemImage: "person.badge.minus")
                        }
                        .tint(.red)
                    }
            }
        }
        .listStyle(.inset)
        .navigationTitle("审核伴游")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            viewModel.getTrips()
        }
    }
}


struct NoAuditTripItemView: View {
    @State var trip: NoAuditTripsModel
    @StateObject var viewModel: NoAuditTripsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 5)  {
            Text(trip.title)
                .font(.system(size: 16, weight: .bold))
            Text(trip.background)
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.black)

            HStack(alignment: .center, spacing: 2)  {
                Text("导游:")
                Text(trip.triperName)
                    .foregroundColor(.black)
                    .font(.system(size: 14, weight: .bold))
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.gray)
            
            HStack(alignment: .center, spacing: 4)  {
                Text(trip.language1)
                Text(trip.language2)
                Text(trip.language3)
                
                Spacer()
                Text(trip.updateTime)
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.gray)
            
            
//            auditButtonView {
//                viewModel.updateTripAuditStatus(tripId: trip.tripId, state: 1)
//            } prevent: {
//                viewModel.updateTripAuditStatus(tripId: trip.tripId, state: 2)
//            }

        }
        
    }
}


#Preview {
    NoAuditTripsView()
}
