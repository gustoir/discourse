import RestrictedUserRoute from "discourse/routes/restricted-user";

export default RestrictedUserRoute.extend({
  showFooter: true,
  setupController(controller, model) {
    controller.set("model", model);
  },
});
