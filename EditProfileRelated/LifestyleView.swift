//
//  LifestyleView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation
import SwiftUI

// Reusable row component for lifestyle options
struct LifestyleRowView<Icon: View>: View {
    let label: String
    let value: String
    let icon: Icon
    let isValueEmpty: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            Text(label)
                .font(.headline)
                .padding(.bottom, 5)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(isValueEmpty ? .green : .gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}

struct LifestyleView: View {
    @Binding var selectedLookingFor: String?
    @Binding var showLookingForView: Bool
    @Binding var selectedPet: String?
    @Binding var showPetSelectionView: Bool
    @Binding var selectedFitnessOption: String?
    @Binding var showFitnessOptions: Bool
    @Binding var selectedSmokingOption: String?
    @Binding var showSmokingOptions: Bool
    @Binding var selectedDrinkOption: String?
    @Binding var showDrinkOptions: Bool
    @Binding var selectedVacationOption: String?
    @Binding var showVacationOptions: Bool
    @Binding var selectedDietPreference: String?
    @Binding var showDietPreferences: Bool
    
    var body: some View {
        // 生活方式
        VStack(alignment: .leading) {
            Text("生活方式")
                .font(.headline)
                .padding(.bottom, 5)
            
            LifestyleRowView(
                label: "想找",
                value: selectedLookingFor ?? "新增",
                icon: Image(systemName: "magnifyingglass"),
                isValueEmpty: selectedLookingFor == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_lookingfor_tapped")
                    showLookingForView = true
                }
            )
            .sheet(isPresented: $showLookingForView) {
                LookingForView(selectedLookingFor: $selectedLookingFor)
            }

            LifestyleRowView(
                label: "寵物",
                value: selectedPet ?? "新增",
                icon: Image(systemName: "pawprint"),
                isValueEmpty: selectedPet == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_pet_tapped")
                    showPetSelectionView = true
                }
            )
            .sheet(isPresented: $showPetSelectionView) {
                PetSelectionView(selectedPet: $selectedPet)
            }

            LifestyleRowView(
                label: "健身",
                value: selectedFitnessOption ?? "新增",
                icon: Image(systemName: "dumbbell"),
                isValueEmpty: selectedFitnessOption == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_fitness_tapped")
                    showFitnessOptions = true
                }
            )
            .sheet(isPresented: $showFitnessOptions) {
                FitnessOptionsView(selectedFitnessOption: $selectedFitnessOption)
            }

            LifestyleRowView(
                label: "抽煙",
                value: selectedSmokingOption ?? "新增",
                icon: Image("smoking")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24),
                isValueEmpty: selectedSmokingOption == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_smoking_tapped")
                    showSmokingOptions = true
                }
            )
            .sheet(isPresented: $showSmokingOptions) {
                SmokingOptionsView(selectedSmokingOption: $selectedSmokingOption)
            }

            LifestyleRowView(
                label: "喝酒",
                value: selectedDrinkOption ?? "新增",
                icon: Image(systemName: "wineglass.fill"),
                isValueEmpty: selectedDrinkOption == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_drink_tapped")
                    showDrinkOptions = true
                }
            )
            .sheet(isPresented: $showDrinkOptions) {
                DrinkOptionsView(selectedDrinkOption: $selectedDrinkOption)
            }

            LifestyleRowView(
                label: "休假日",
                value: selectedVacationOption ?? "新增",
                icon: Image(systemName: "tree.fill"),
                isValueEmpty: selectedVacationOption == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_vacation_tapped")
                    showVacationOptions = true
                }
            )
            .sheet(isPresented: $showVacationOptions) {
                VacationOptionsView(selectedVacationOption: $selectedVacationOption)
            }

            LifestyleRowView(
                label: "飲食習慣",
                value: selectedDietPreference ?? "新增",
                icon: Image(systemName: "fork.knife"),
                isValueEmpty: selectedDietPreference == nil,
                onTap: {
                    AnalyticsManager.shared.trackEvent("lifestyle_diet_tapped")
                    showDietPreferences = true
                }
            )
            .sheet(isPresented: $showDietPreferences) {
                DietPreferencesView(selectedDietPreference: $selectedDietPreference)
            }

            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            // 埋點：頁面曝光
            AnalyticsManager.shared.trackEvent("lifestyle_view_appear")
        }
    }
}

struct LifestyleView_Previews: PreviewProvider {
    @State static var selectedLookingFor: String? = "穩定的關係"
    @State static var showLookingForView = false
    @State static var selectedPet: String? = "沒有寵物"
    @State static var showPetSelectionView = false
    @State static var selectedFitnessOption: String? = "經常健身"
    @State static var showFitnessOptions = false
    @State static var selectedSmokingOption: String? = "不抽煙"
    @State static var showSmokingOptions = false
    @State static var selectedDrinkOption: String? = "偶爾喝酒"
    @State static var showDrinkOptions = false
    @State static var selectedVacationOption: String? = "時間自己掌控"
    @State static var showVacationOptions = false
    @State static var selectedDietPreference: String? = "其他飲食偏好"
    @State static var showDietPreferences = false
    
    static var previews: some View {
        LifestyleView(
            selectedLookingFor: $selectedLookingFor,
            showLookingForView: $showLookingForView,
            selectedPet: $selectedPet,
            showPetSelectionView: $showPetSelectionView,
            selectedFitnessOption: $selectedFitnessOption,
            showFitnessOptions: $showFitnessOptions,
            selectedSmokingOption: $selectedSmokingOption,
            showSmokingOptions: $showSmokingOptions,
            selectedDrinkOption: $selectedDrinkOption,
            showDrinkOptions: $showDrinkOptions,
            selectedVacationOption: $selectedVacationOption,
            showVacationOptions: $showVacationOptions,
            selectedDietPreference: $selectedDietPreference,
            showDietPreferences: $showDietPreferences
        )
    }
}
