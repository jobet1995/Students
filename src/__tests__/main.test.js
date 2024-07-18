import { render } from "@testing-library/vue";
import App from "@/App.vue";

describe("App.vue", () => {
  it("renders props.msg when passed", () => {
    const msg = "test";
    const { getByText } = render(App, {
      props: { msg },
    });
    expect(getByText(msg));
  });
});
