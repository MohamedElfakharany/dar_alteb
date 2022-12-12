import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dar_elteb/cubit/cubit.dart';
import 'package:dar_elteb/cubit/states.dart';
import 'package:dar_elteb/screens/main_screens/tech_support_screens/create_tech_support_screen.dart';
import 'package:dar_elteb/screens/main_screens/tech_support_screens/widget_component.dart';
import 'package:dar_elteb/shared/components/general_components.dart';
import 'package:dar_elteb/shared/constants/colors.dart';
import 'package:dar_elteb/shared/constants/general_constants.dart';
import 'package:dar_elteb/translations/locale_keys.g.dart';

class TechnicalSupportScreen extends StatefulWidget {
  const TechnicalSupportScreen({Key? key}) : super(key: key);

  @override
  State<TechnicalSupportScreen> createState() => _TechnicalSupportScreenState();
}

class _TechnicalSupportScreenState extends State<TechnicalSupportScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).getUserRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppCancelTechRequestsSuccessState) {
          if (state.successModel.status) {
            showToast(
                msg: state.successModel.message, state: ToastState.success);
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.successModel.message),
                );
              },
            );
          }
        } else if (state is AppCancelTechRequestsErrorState) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(state.error.toString()),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: greyExtraLightColor,
          appBar: GeneralAppBar(
            title: LocaleKeys.TxtReservationScreenTitle.tr(),
            appBarColor: greyExtraLightColor,
            centerTitle: false,
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(right: 20.0, bottom: 20.0, left: 20.0),
            child: Column(
              children: [
                GeneralButton(
                  title:
                      '${LocaleKeys.TxtReservationScreenTitle.tr()} ${LocaleKeys.txtNow.tr()}',
                  onPress: () {
                    Navigator.push(context,
                        FadeRoute(page: const CreateTechSupportScreen()));
                  },
                ),
                verticalMediumSpace,
                if (AppCubit.get(context).patientTechnicalSupportModel?.data != null)
                  ConditionalBuilder(
                    condition: AppCubit.get(context).patientTechnicalSupportModel?.data?.date?.date?.isEmpty == false,
                    builder: (context) => ConditionalBuilder(
                      condition: state is! AppGetTechRequestLoadingState,
                      builder: (context) => const UserRequestsCart(),
                      fallback: (context) => const Center(
                          child: CircularProgressIndicator.adaptive()),
                    ),
                    fallback: (context) => ScreenHolder(
                        msg: LocaleKeys.TxtReservationScreenTitle.tr()),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
